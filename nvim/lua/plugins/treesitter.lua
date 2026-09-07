-- Parsers to keep installed (in addition to the ones bundled with Neovim)
local wanted_parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "fish",
  "git_config",
  "gitcommit",
  "go",
  "gomod",
  "gosum",
  "hcl",
  "html",
  "javascript",
  "json",
  "jsonnet",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "proto",
  "python",
  "regex",
  "rust",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

-- Install parsers from `wanted_parsers` that are not installed yet.
-- nvim-treesitter (main branch) needs the tree-sitter CLI to build parsers.
local function install_missing_parsers()
  local ts = require("nvim-treesitter")
  local installed = ts.get_installed()
  local missing = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed, lang)
  end, wanted_parsers)
  if #missing == 0 then
    return
  end
  if vim.fn.executable("tree-sitter") ~= 1 then
    vim.notify(
      "nvim-treesitter: tree-sitter CLI not found, cannot install parsers: " .. table.concat(missing, ", "),
      vim.log.levels.WARN
    )
    return
  end
  ts.install(missing)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("nvim-treesitter").setup({})

      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Text objects
      local select_maps = {
        { "af", "@function.outer", "Outer function" },
        { "if", "@function.inner", "Inner function" },
        { "ac", "@class.outer", "Outer class" },
        { "ic", "@class.inner", "Inner class" },
        { "aa", "@parameter.outer", "Outer argument" },
        { "ia", "@parameter.inner", "Inner argument" },
      }
      for _, m in ipairs(select_maps) do
        vim.keymap.set({ "x", "o" }, m[1], function()
          select.select_textobject(m[2], "textobjects")
        end, { desc = m[3] })
      end

      -- Motions. ]f/[f and ]a/[a are taken by vim-unimpaired (files, args),
      -- ]c/[c by diff/gitsigns, so use m (method), k (klass) and r (aRgument).
      local motions = {
        { "]m", move.goto_next_start, "@function.outer", "Next function start" },
        { "[m", move.goto_previous_start, "@function.outer", "Previous function start" },
        { "]M", move.goto_next_end, "@function.outer", "Next function end" },
        { "[M", move.goto_previous_end, "@function.outer", "Previous function end" },
        { "]k", move.goto_next_start, "@class.outer", "Next class start" },
        { "[k", move.goto_previous_start, "@class.outer", "Previous class start" },
        { "]K", move.goto_next_end, "@class.outer", "Next class end" },
        { "[K", move.goto_previous_end, "@class.outer", "Previous class end" },
        { "]r", move.goto_next_start, "@parameter.outer", "Next argument" },
        { "[r", move.goto_previous_start, "@parameter.outer", "Previous argument" },
      }
      for _, m in ipairs(motions) do
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          m[2](m[3], "textobjects")
        end, { desc = m[4] })
      end

      local ts_group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = ts_group,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Make sure custom parsers are registered before an update
      vim.api.nvim_create_autocmd("User", {
        group = ts_group,
        pattern = "TSUpdate",
        once = true,
        callback = install_missing_parsers,
      })

      install_missing_parsers()
    end,
  },
}
