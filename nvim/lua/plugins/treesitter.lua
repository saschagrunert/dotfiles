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

      local select_maps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      local next_maps = {
        ["]f"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]a"] = "@parameter.outer",
      }
      for key, query in pairs(next_maps) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          move.goto_next_start(query, "textobjects")
        end)
      end

      local prev_maps = {
        ["[f"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[a"] = "@parameter.outer",
      }
      for key, query in pairs(prev_maps) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          move.goto_previous_start(query, "textobjects")
        end)
      end

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
