return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({})

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          if pcall(require, "nvim-treesitter.indent") then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        once = true,
        callback = function()
          local installed = require("nvim-treesitter").get_installed()
          local wanted = {
            "bash", "c", "cpp", "css", "diff",
            "dockerfile", "fish", "go", "gomod", "gosum",
            "hcl", "html", "javascript", "json", "jsonnet",
            "lua", "make", "markdown", "markdown_inline", "nix",
            "proto", "python", "regex", "rust", "terraform",
            "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
          }
          local missing = vim.tbl_filter(function(lang)
            return not vim.list_contains(installed, lang)
          end, wanted)
          if #missing > 0 then
            require("nvim-treesitter").install(missing)
          end
        end,
      })
    end,
  },
}
