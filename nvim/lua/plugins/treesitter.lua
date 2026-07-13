return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "fish",
          "go", "gomod", "gosum", "hcl", "html",
          "javascript", "json", "jsonnet", "lua", "make",
          "markdown", "markdown_inline", "nix", "proto", "python",
          "rust", "terraform", "toml", "tsx",
          "typescript", "vim", "vimdoc", "yaml",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
