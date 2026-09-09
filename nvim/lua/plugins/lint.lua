return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        bash = { "shellcheck" },
        go = { "golangcilint" },
        nix = { "statix" },
        python = { "ruff" },
        sh = { "shellcheck" },
        yaml = { "yamllint" },
      }

      -- Lint on open and after every write (also covers new files once saved)
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("Lint", { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
