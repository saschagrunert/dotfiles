return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "dockerfile", "fish",
          "go", "gomod", "gosum", "haskell", "hcl", "html",
          "javascript", "json", "jsonnet", "lua", "make",
          "markdown", "markdown_inline", "nix", "proto", "python",
          "ruby", "rust", "terraform", "toml", "tsx",
          "typescript", "vim", "vimdoc", "yaml",
        },
      })

      -- Enable treesitter highlight and indent for all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
