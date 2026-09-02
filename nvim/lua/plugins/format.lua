return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettier" },
        fish = { "fish_indent" },
        go = { "goimports", "gofumpt" },
        html = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        less = { "prettier" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        proto = { "clang-format" },
        python = { "ruff_format" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        terraform = { lsp_format = "prefer" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      format_after_save = {},
      formatters = {
        shfmt = { prepend_args = { "-i", "0" } },
      },
    },
  },
}
