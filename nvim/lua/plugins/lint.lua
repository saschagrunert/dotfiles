return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        haskell = { "hlint" },
        markdown = { "proselint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
    end,
  },
}
