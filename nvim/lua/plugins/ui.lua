return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          show_close_icon = false,
          show_buffer_close_icons = false,
          separator_style = "thin",
        },
      })
      local function set_fill_bg()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        local bg = normal.bg and string.format("#%06x", normal.bg) or "#282a36"
        vim.api.nvim_set_hl(0, "BufferLineFill", { bg = bg })
      end
      set_fill_bg()
      local bufferline_group = vim.api.nvim_create_augroup("BufferLineFill", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", { group = bufferline_group, callback = set_fill_bg })
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
    opts = {
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Git" },
        { "<leader>u", group = "Case" },
        { "<leader>r", group = "Replace" },
        { "<leader>c", group = "Code" },
        { "<leader>t", group = "Tabs" },
      },
    },
  },
}
