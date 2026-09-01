return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        bash = { "shellcheck" },
        go = { "golangcilint" },
        markdown = { "proselint" },
        nix = { "statix" },
        python = { "ruff" },
        sh = { "shellcheck" },
        yaml = { "yamllint" },
      }
    end,
  },
}
