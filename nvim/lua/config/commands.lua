local M = {}

-- Check if there's a window in the given direction
function M.has_window(side)
  local eventignore = vim.o.eventignore
  vim.o.eventignore = "all"
  local crr_win = vim.fn.winnr()
  vim.cmd("5wincmd " .. side)
  local result = vim.fn.winnr() ~= crr_win
  if result then
    vim.cmd(crr_win .. "wincmd w")
  end
  vim.o.eventignore = eventignore
  return result
end

-- Smart window resizing based on position
function M.resize_window(dir)
  local crr_win = vim.fn.winnr()
  if dir == "h" then
    if M.has_window("h") and not M.has_window("l") then
      vim.cmd("5wincmd >")
    elseif M.has_window("h") and M.has_window("l") then
      vim.cmd("5wincmd l")
      vim.cmd("5wincmd >")
      vim.cmd(crr_win .. "wincmd w")
    elseif M.has_window("l") and not M.has_window("h") then
      vim.cmd("5wincmd <")
    end
  elseif dir == "l" then
    if M.has_window("l") and not M.has_window("h") then
      vim.cmd("5wincmd >")
    elseif M.has_window("l") and M.has_window("h") then
      vim.cmd("5wincmd l")
      vim.cmd("5wincmd <")
      vim.cmd(crr_win .. "wincmd w")
    elseif M.has_window("h") and not M.has_window("l") then
      vim.cmd("5wincmd <")
    end
  elseif dir == "k" then
    if M.has_window("j") and not M.has_window("k") then
      vim.cmd("5wincmd -")
    elseif M.has_window("j") and M.has_window("k") then
      vim.cmd("5wincmd j")
      vim.cmd("5wincmd +")
      vim.cmd(crr_win .. "wincmd w")
    elseif M.has_window("k") then
      vim.cmd("5wincmd +")
    elseif M.has_window("j") then
      vim.cmd("5wincmd j")
      vim.cmd("5wincmd +")
      vim.cmd(crr_win .. "wincmd w")
    end
  elseif dir == "j" then
    if M.has_window("j") then
      vim.cmd("5wincmd +")
    elseif M.has_window("k") then
      vim.cmd("5wincmd k")
      vim.cmd("5wincmd +")
      vim.cmd(crr_win .. "wincmd w")
    end
  end
end

-- Toggle quickfix/location list
function M.toggle_list(bufname, pfx)
  local buflist = vim.fn.execute("silent! ls")
  for _, line in ipairs(vim.split(buflist, "\n")) do
    if line:find(bufname) then
      local bufnum = tonumber(line:match("(%d+)"))
      if bufnum and #vim.fn.win_findbuf(bufnum) > 0 then
        vim.cmd(pfx .. "close")
        return
      end
    end
  end
  local ok, err = pcall(vim.cmd, pfx .. "open")
  if not ok then
    vim.notify(err, vim.log.levels.WARN)
  end
end

-- Toggle color column
function M.toggle_color_column()
  if vim.wo.colorcolumn ~= "" then
    vim.wo.colorcolumn = ""
  else
    vim.wo.colorcolumn = "80"
  end
end

-- Toggle hex editor mode
function M.toggle_hex()
  local modified = vim.bo.modified
  local oldreadonly = vim.bo.readonly
  vim.bo.readonly = false
  local oldmodifiable = vim.bo.modifiable
  vim.bo.modifiable = true

  if not vim.b.editHex then
    vim.b.oldft = vim.bo.filetype
    vim.b.oldbin = vim.bo.binary
    vim.bo.binary = true
    vim.bo.filetype = "xxd"
    vim.b.editHex = true
    vim.cmd("%!xxd -g 1")
  else
    vim.bo.filetype = vim.b.oldft or ""
    if not vim.b.oldbin then
      vim.bo.binary = false
    end
    vim.b.editHex = false
    vim.cmd("%!xxd -r")
  end

  vim.bo.modified = modified
  vim.bo.readonly = oldreadonly
  vim.bo.modifiable = oldmodifiable
end

-- Visual search (makes * and # work in visual mode)
function M.visual_search(cmdtype)
  local temp = vim.fn.getreg("s")
  vim.cmd('normal! gv"sy')
  local pattern = "\\V" .. vim.fn.escape(vim.fn.getreg("s"), cmdtype .. "\\"):gsub("\n", "\\n")
  vim.fn.setreg("/", pattern)
  vim.fn.setreg("s", temp)
end

-- Close all buffers except current
function M.buf_only()
  local current = vim.fn.bufnr("%")
  local last = vim.fn.bufnr("$")
  local count = 0
  for i = 1, last do
    if i ~= current and vim.fn.buflisted(i) == 1 then
      local ok = pcall(vim.cmd, "bdel " .. i)
      if ok and vim.fn.buflisted(i) == 0 then
        count = count + 1
      end
    end
  end
  vim.notify(count .. " buffer(s) deleted")
end

-- Delete all non-visible buffers
function M.wipeout(bang)
  local visible = {}
  for t = 1, vim.fn.tabpagenr("$") do
    for _, b in ipairs(vim.fn.tabpagebuflist(t)) do
      visible[b] = true
    end
  end
  local tally = 0
  local cmd = bang and "bw!" or "bw"
  for b = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(b) == 1 and not visible[b] then
      pcall(vim.cmd, cmd .. " " .. b)
      tally = tally + 1
    end
  end
  vim.notify("Deleted " .. tally .. " buffers")
end

-- Toggle syntax-based folding
function M.toggle_folding()
  if not vim.b.outline_mode or vim.b.outline_mode == 0 then
    vim.notify("Enabling syntax based folding.")
    vim.opt_local.foldmethod = "syntax"
    vim.opt_local.foldenable = true
    vim.b.outline_mode = 1
  else
    vim.notify("Disabling syntax based folding.")
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldenable = false
    vim.b.outline_mode = 0
  end
end

-- Quickfix filenames (for Qargs)
function M.quickfix_filenames()
  local buffers = {}
  for _, item in ipairs(vim.fn.getqflist()) do
    buffers[item.bufnr] = vim.fn.bufname(item.bufnr)
  end
  local names = {}
  for _, name in pairs(buffers) do
    table.insert(names, vim.fn.fnameescape(name))
  end
  return table.concat(names, " ")
end

-- Commands
vim.api.nvim_create_user_command("Matches", ":%s///gn", {})
vim.api.nvim_create_user_command("KillWhitespace", ":%s/\\s\\+$//", {})
vim.api.nvim_create_user_command("Hexmode", function() M.toggle_hex() end, { bar = true })
vim.api.nvim_create_user_command("BufOnly", function(opts)
  M.buf_only()
end, { bang = true })
vim.api.nvim_create_user_command("Wipeout", function(opts)
  M.wipeout(opts.bang)
end, { bang = true })
vim.api.nvim_create_user_command("PrettyJSON", ":%!python -m json.tool", {})
vim.api.nvim_create_user_command("Qargs", function()
  vim.cmd("args " .. M.quickfix_filenames())
end, { bar = true })

return M
