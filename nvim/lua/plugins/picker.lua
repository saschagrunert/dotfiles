return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<S-Tab>", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document symbols" },
      { "cpi", "<cmd>FzfLua blines<cr>", desc = "Buffer lines" },
      { "cpk", "<cmd>FzfLua marks<cr>", desc = "Marks" },
      { "cpm", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
      { "cpp", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "cpq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix" },
      { "cpl", "<cmd>FzfLua loclist<cr>", desc = "Location list" },
      { "cpr", "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "cpg", "<cmd>FzfLua git_commits<cr>", desc = "Git commits" },
      { "cpb", "<cmd>FzfLua git_branches<cr>", desc = "Git branches" },
      { "cpf", "<cmd>FzfLua git_status<cr>", desc = "Git status files" },
      { "<leader>rg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
    },
    config = function()
      require("fzf-lua").setup({
        "default-title",
        winopts = {
          preview = { layout = "horizontal", horizontal = "right:55%" },
        },
        files = {
          cmd = "fd --type f --hidden --exclude .git",
        },
        grep = {
          rg_opts = "--hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        },
      })
    end,
  },
}
