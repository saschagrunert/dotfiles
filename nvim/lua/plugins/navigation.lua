return {
  {
    "easymotion/vim-easymotion",
    event = "VeryLazy",
    init = function()
      vim.g.EasyMotion_smartcase = 1
      vim.g.EasyMotion_enter_jump_first = 1
      vim.g.EasyMotion_space_jump_first = 1
      vim.g.EasyMotion_move_highlight = 0
      vim.g.EasyMotion_startofline = 0
    end,
    keys = {
      { "s", "<Plug>(easymotion-overwin-f2)", mode = "n" },
      { "s", "<Plug>(easymotion-s2)", mode = "x" },
      { "z", "<Plug>(easymotion-s2)", mode = "o" },

      { "S", "<Plug>(easymotion-sn)", mode = "n" },
      { "Z", "<Plug>(easymotion-sn)", mode = { "x", "o" } },

      { "<leader><leader>S", "<Plug>(easymotion-jumptoanywhere)", mode = { "n", "x", "o" } },

      { "f", "<Plug>(easymotion-fl)", mode = { "n", "x", "o" } },
      { "F", "<Plug>(easymotion-Fl)", mode = { "n", "x", "o" } },

      { "t", "<Plug>(easymotion-tl)", mode = { "x", "o" } },
      { "T", "<Plug>(easymotion-Tl)", mode = { "x", "o" } },

      { ",", "<Plug>(easymotion-next)", mode = "n" },
      { ";", "<Plug>(easymotion-prev)", mode = "n" },

      { "j", "<Plug>(easymotion-j)", mode = "n" },
      { "k", "<Plug>(easymotion-k)", mode = "n" },
      { "l", "<Plug>(easymotion-lineforward)", mode = "n" },
      { "h", "<Plug>(easymotion-linebackward)", mode = "n" },

      { "<leader>j", "<Plug>(easymotion-j)", mode = "v" },
      { "<leader>k", "<Plug>(easymotion-k)", mode = "v" },
      { "<leader>h", "<Plug>(easymotion-linebackward)", mode = "v" },
      { "<leader>l", "<Plug>(easymotion-lineforward)", mode = "v" },

      { "<leader><leader>J", "<Plug>(easymotion-eol-j)" },
      { "<leader><leader>K", "<Plug>(easymotion-eol-k)" },
    },
  },
}
