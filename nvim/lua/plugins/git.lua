return {
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
      { "<leader>gd", "<cmd>Neogit diff<cr>", desc = "Git diff" },
      { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Git pull" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git push" },
      { "<leader>gf", "<cmd>Neogit fetch<cr>", desc = "Git fetch" },
      { "<leader>go", "<cmd>Neogit pull --rebase<cr>", desc = "Git pull rebase" },
    },
    opts = {
      integrations = { fzf_lua = true },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "|" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.nav_hunk("next")
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.nav_hunk("prev")
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev hunk" })
        map("n", "<leader>gh", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gu", gs.reset_hunk, { desc = "Reset hunk" })
        map("n", "<leader>gb", gs.blame, { desc = "Git blame" })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Inner hunk" })
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Outer hunk" })
      end,
    },
  },
}
