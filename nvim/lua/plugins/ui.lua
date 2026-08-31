return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
      local bg = normal.bg and string.format("#%06x", normal.bg) or "#282a36"
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          show_close_icon = false,
          show_buffer_close_icons = false,
          separator_style = "thin",
        },
      })
      vim.api.nvim_set_hl(0, "BufferLineFill", { bg = bg })
    end,
  },
  {
    "mbbill/undotree",
    keys = {
      { "cmu", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
