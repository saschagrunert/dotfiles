return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({})

      local ts_group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = ts_group,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = ts_group,
        pattern = "TSUpdate",
        once = true,
        callback = function()
          local installed = require("nvim-treesitter").get_installed()
          local wanted = {
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
