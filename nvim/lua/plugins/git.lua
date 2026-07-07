return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gwrite", "Gread", "Gedit" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff" },
      { "<leader>gc", "<cmd>Gwrite<bar>w<bar>Git commit<cr>A", desc = "Git commit" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git write" },
      { "<leader>gr", "<cmd>Gread<cr>", desc = "Git read" },
      { "<leader>ge", "<cmd>Gedit<cr>", desc = "Git edit" },
      { "<leader>gp", "<cmd>w<bar>Git push<cr>", desc = "Git push" },
      { "<leader>gf", "<cmd>Git fetch<cr>", desc = "Git fetch" },
      { "<leader>go", "<cmd>Git pull --rebase<cr>", desc = "Git pull rebase" },
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
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev hunk" })
        map("n", "<leader>gh", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Inner hunk" })
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Outer hunk" })
      end,
    },
  },
}
