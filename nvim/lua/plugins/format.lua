return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettier" },
        go = { "gofumpt" },
        haskell = { "floskell" },
        html = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        less = { "prettier" },
        markdown = { "prettier" },
        nix = { "nixpkgs-fmt" },
        proto = { "clang-format" },
        python = { "autopep8", "isort" },
        rust = { "rustfmt" },
        scss = { "prettier" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        typescript = { "prettier" },
      },
      format_after_save = {
        lsp_format = "fallback",
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "4" } },
        rustfmt = { prepend_args = { "--edition=2021" } },
      },
    },
  },
}
