return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<S-TAB>", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "cpc", "<cmd>Telescope tags<cr>", desc = "Tags" },
      { "cpi", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer lines" },
      { "cpk", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "cpm", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "cpp", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "cpq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "cpl", "<cmd>Telescope loclist<cr>", desc = "Location list" },
      { "cpr", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "cpg", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "cpb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "cpf", "<cmd>Telescope git_status<cr>", desc = "Git status files" },
      { "<leader>rg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_config = {
            horizontal = { preview_width = 0.55 },
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
          file_ignore_patterns = { "vendor/", "node_modules/", ".git/" },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
}
