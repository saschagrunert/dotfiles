-- Format on save only runs the formatters that already agree with the committed
-- version of the file. Saving a small change to a file that follows another
-- style (an upstream project, or ~/.clang-format and ~/.rustfmt.toml applied
-- outside your own projects) then no longer reformats the whole file. Files
-- without a committed version (new, untracked or outside git) use every
-- formatter. <leader>cf always formats with everything and turns format on save
-- back on for the buffer.
--
-- vim.b.autoformat: nil or true runs every formatter on save, false skips
-- formatting while the check runs, a list names the formatters to run.

local MAX_CHECKS = 4 -- concurrent checks, so :bufdo or :cdo don't start hundreds of formatters
local CHECK_TIMEOUT_MS = 10000
local MAX_FILE_SIZE = 1024 * 1024 -- larger files are not formatted on save

local checks = {} -- latest check id per buffer, older results are dropped
local queue, running = {}, 0

-- Run each formatter on the committed version of the buffer's file and store the
-- ones that leave it unchanged. Working on a copy of the text keeps the check
-- independent of edits made while it runs.
local function check_formatters(bufnr, id, done)
  local conform = require("conform")
  local formatters, clean = {}, {}
  local finished = false
  local function current()
    return checks[bufnr] == id and vim.api.nvim_buf_is_valid(bufnr)
  end
  local function finish(result)
    if finished then
      return
    end
    finished = true
    if current() then
      if result == nil then
        -- Keep the formatter order, since later formatters build on earlier ones
        result = {}
        for _, formatter in ipairs(formatters) do
          if clean[formatter.name] then
            table.insert(result, formatter.name)
          end
        end
      end
      vim.b[bufnr].autoformat = result
    end
    done()
  end

  local path = current() and vim.api.nvim_buf_get_name(bufnr) or ""
  if path == "" or vim.bo[bufnr].buftype ~= "" then
    return finish(true)
  end
  path = vim.uv.fs_realpath(path) or path
  local stat = vim.uv.fs_stat(path)
  if stat and stat.size > MAX_FILE_SIZE then
    return finish({})
  end
  formatters = conform.list_formatters_to_run(bufnr)
  if #formatters == 0 then
    return finish({})
  end
  -- A formatter that has not answered in time is unknown, not dirty. Recording
  -- the partial result would turn format on save off for the rest of the
  -- session, so fall back to running every formatter instead.
  vim.defer_fn(function()
    finish(true)
  end, CHECK_TIMEOUT_MS)

  local ok = pcall(
    vim.system,
    { "git", "show", "HEAD:./" .. vim.fs.basename(path) },
    { cwd = vim.fs.dirname(path), text = true },
    vim.schedule_wrap(function(obj)
      if obj.code ~= 0 or not current() then
        return finish(true)
      end
      local lines = vim.split(obj.stdout, "\n", { plain = true })
      if lines[#lines] == "" then
        table.remove(lines)
      end
      local pending = #formatters
      local function formatter_done(name, is_clean)
        clean[name] = is_clean
        pending = pending - 1
        if pending == 0 then
          finish()
        end
      end
      for _, formatter in ipairs(formatters) do
        local started = pcall(
          conform.format_lines,
          { formatter.name },
          vim.deepcopy(lines),
          { bufnr = bufnr, async = true, quiet = true },
          function(err, output)
            formatter_done(formatter.name, not err and vim.deep_equal(output, lines))
          end
        )
        if not started then
          formatter_done(formatter.name, false)
        end
      end
    end)
  )
  -- git is missing or the directory is gone, so there is no committed version
  if not ok then
    finish(true)
  end
end

local function run_queue()
  while running < MAX_CHECKS and #queue > 0 do
    running = running + 1
    local job = table.remove(queue, 1)
    local released = false
    local function done()
      if not released then
        released = true
        running = running - 1
        vim.schedule(run_queue)
      end
    end
    local ok, err = pcall(check_formatters, job.bufnr, job.id, done)
    if not ok then
      if checks[job.bufnr] == job.id and vim.api.nvim_buf_is_valid(job.bufnr) then
        vim.b[job.bufnr].autoformat = true
      end
      vim.notify("Format on save check failed: " .. tostring(err), vim.log.levels.WARN)
      done()
    end
  end
end

-- pending: skip formatting on save until the check is done. A renamed buffer or
-- new filetype keeps its current setting instead, so writing a buffer that just
-- got its name still formats it.
local function queue_check(bufnr, pending)
  local id = (checks[bufnr] or 0) + 1
  checks[bufnr] = id
  if pending then
    vim.b[bufnr].autoformat = false
  end
  -- Scheduled so modeline filetypes and plugins setting buftype apply first
  vim.schedule(function()
    table.insert(queue, { bufnr = bufnr, id = id })
    run_queue()
  end)
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    init = function()
      local group = vim.api.nvim_create_augroup("FormatOnSaveCheck", { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = group,
        callback = function(args)
          queue_check(args.buf, true)
        end,
      })
      -- A new name (:saveas, :file) or filetype changes which formatters apply
      vim.api.nvim_create_autocmd("BufFilePost", {
        group = group,
        callback = function(args)
          queue_check(args.buf, false)
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          -- Only for checked buffers; reading a file already queued a check
          local autoformat = vim.b[args.buf].autoformat
          if autoformat ~= nil and autoformat ~= false then
            queue_check(args.buf, false)
          end
        end,
      })
      vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        callback = function(args)
          checks[args.buf] = nil
        end,
      })
    end,
    keys = {
      {
        "<leader>cf",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          -- Drop the result of a running check, so it cannot turn format on save off again
          checks[bufnr] = (checks[bufnr] or 0) + 1
          require("conform").format({ async = true }, function(err)
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            elseif not err then
              vim.b[bufnr].autoformat = true
            elseif vim.b[bufnr].autoformat == false then
              -- The dropped check never finished, so run it again
              queue_check(bufnr, true)
            end
          end)
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettier" },
        fish = { "fish_indent" },
        go = { "goimports", "gofumpt", "gofmt" },
        html = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        less = { "prettier" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        proto = { "clang-format" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      -- LSP formatting only runs from <leader>cf, not on save
      format_after_save = function(bufnr)
        local autoformat = vim.b[bufnr].autoformat
        if autoformat == nil or autoformat == true then
          return { lsp_format = "never" }
        elseif type(autoformat) == "table" and #autoformat > 0 then
          return { formatters = autoformat, lsp_format = "never" }
        end
      end,
      formatters = {
        -- No -i: conform would pass the buffer's shiftwidth, overriding any
        -- prepended -i. Without it shfmt reads .editorconfig or uses tabs.
        shfmt = { args = { "-filename", "$FILENAME" } },
      },
    },
  },
}
