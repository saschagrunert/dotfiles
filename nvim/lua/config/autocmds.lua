local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Show diagnostic float on hover (only when diagnostics exist)
autocmd("CursorHold", {
  group = augroup("DiagnosticFloat", { clear = true }),
  callback = function()
    if #vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }) > 0 then
      vim.diagnostic.open_float({ focusable = false })
    end
  end,
})

-- Filetype-specific indentation
autocmd("FileType", {
  group = augroup("FiletypeIndent", { clear = true }),
  pattern = { "typescript", "ruby", "rdoc", "cucumber", "haskell", "yaml" },
  callback = function()
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Text files: textwidth
autocmd("FileType", {
  group = augroup("TextWidth", { clear = true }),
  pattern = { "plaintex", "text", "markdown", "tex" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

-- Auto-adjust quickfix height
autocmd("FileType", {
  group = augroup("QuickfixHeight", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.opt_local.wrap = false
    local lines = vim.fn.line("$")
    local height = math.max(1, math.min(lines, 10))
    vim.cmd(height .. "wincmd _")
  end,
})

-- Git commit: jj to save and close
autocmd("FileType", {
  group = augroup("GitCommit", { clear = true }),
  pattern = "gitcommit",
  callback = function()
    vim.keymap.set("i", "jj", "<ESC>ZZ", { buffer = true })
  end,
})

-- Go: use tabs for listchars
autocmd("FileType", {
  group = augroup("GoListchars", { clear = true }),
  pattern = "go",
  callback = function()
    vim.opt_local.listchars = { tab = "  ", trail = "·", extends = "❯", precedes = "❮" }
  end,
})

-- Lint on save
autocmd("BufWritePost", {
  group = augroup("LintOnSave", { clear = true }),
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then lint.try_lint() end
  end,
})

-- Run commands per filetype
local ft_runner_group = augroup("FiletypeRunners", { clear = true })
local ft_runners = {
  bash = "bash", javascript = "node", perl = "perl",
  php = "php", python = "python", ruby = "ruby", sh = "sh",
}
for ft, cmd in pairs(ft_runners) do
  autocmd("FileType", {
    group = ft_runner_group,
    pattern = ft,
    callback = function()
      vim.keymap.set("n", "<leader>r", "<cmd>write !" .. cmd .. "<cr>", { buffer = true, silent = true })
    end,
  })
end
autocmd("FileType", {
  group = ft_runner_group,
  pattern = "c",
  callback = function()
    vim.keymap.set("n", "<leader>r", "<cmd>write | !gcc -o %:r -Wall -std=c99 % && ./%:r<cr>", { buffer = true, silent = true })
  end,
})
