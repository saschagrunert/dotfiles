local autocmd = vim.api.nvim_create_autocmd

-- Show diagnostic float on hover (only when diagnostics exist)
autocmd("CursorHold", {
  callback = function()
    if #vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }) > 0 then
      vim.diagnostic.open_float({ focusable = false })
    end
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

-- Lint on save
autocmd("BufWritePost", {
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
