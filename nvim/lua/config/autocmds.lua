local autocmd = vim.api.nvim_create_autocmd

-- Show diagnostic float on hover
autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float({ focusable = false })
  end,
})

-- Filetype-specific indentation
autocmd("FileType", {
  pattern = { "typescript", "ruby", "rdoc", "cucumber", "haskell", "yaml" },
  callback = function()
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Text files: textwidth
autocmd("FileType", {
  pattern = { "plaintex", "text", "markdown", "tex" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

-- Return to last edit position
autocmd("BufReadPost", {
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 0 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Auto-adjust quickfix height
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = false
    local lines = vim.fn.line("$")
    local height = math.max(1, math.min(lines, 10))
    vim.cmd(height .. "wincmd _")
  end,
})

-- Markdown: force filetype for .md files
autocmd({ "BufNewFile", "BufReadPost" }, {
  pattern = "*.md",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

-- Git commit: jj to save and close
autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.keymap.set("i", "jj", "<ESC>ZZ", { buffer = true })
  end,
})

-- Go: use tabs for listchars
autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.listchars = { tab = "  ", trail = "·", extends = "❯", precedes = "❮" }
  end,
})

-- Haskell settings
autocmd("FileType", {
  pattern = "haskell",
  callback = function()
    vim.g.haskell_enable_quantification = 1
    vim.g.haskell_enable_recursivedo = 1
    vim.g.haskell_enable_arrowsyntax = 1
    vim.g.haskell_enable_pattern_synonyms = 1
    vim.g.haskell_enable_typeroles = 1
    vim.g.haskell_enable_static_pointers = 1
    vim.g.haskell_backpack = 1
    vim.g.haskell_classic_highlighting = 1
    vim.g.cabal_indent_section = 2
    vim.g.haskell_indent_if = 3
    vim.g.haskell_indent_case = 2
    vim.g.haskell_indent_let = 4
    vim.g.haskell_indent_where = 6
    vim.g.haskell_indent_before_where = 2
    vim.g.haskell_indent_after_bare_where = 2
    vim.g.haskell_indent_do = 3
    vim.g.haskell_indent_in = 1
    vim.g.haskell_indent_guard = 2
  end,
})

-- Lint on save/insert leave
autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then lint.try_lint() end
  end,
})

-- Run commands per filetype
local ft_runners = {
  bash = "bash", javascript = "node", perl = "perl",
  php = "php", python = "python", ruby = "ruby", sh = "sh",
}
for ft, cmd in pairs(ft_runners) do
  autocmd("FileType", {
    pattern = ft,
    callback = function()
      vim.keymap.set("n", "<leader>r", "<cmd>write !" .. cmd .. "<cr>", { buffer = true, silent = true })
    end,
  })
end
autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.keymap.set("n", "<leader>r", "<cmd>write | !gcc -o %:r -Wall -std=c99 % && ./%:r<cr>", { buffer = true, silent = true })
  end,
})
