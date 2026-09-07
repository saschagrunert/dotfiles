return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- Types for vim.uv
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
