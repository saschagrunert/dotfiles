return {
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-abolish", event = "VeryLazy" },
  { "tpope/vim-eunuch", cmd = { "Remove", "Rename", "Mkdir", "Move", "Chmod", "SudoWrite", "SudoEdit", "Wall" } },
  { "tommcdo/vim-exchange", keys = { "cx", { "X", mode = "v" } } },
  { "tpope/vim-speeddating", keys = { "<C-a>", "<C-x>" } },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "wellle/targets.vim", event = "VeryLazy" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
  {
    "zirrostig/vim-schlepp",
    keys = {
      { "k", "<Plug>SchleppUp", mode = "v" },
      { "j", "<Plug>SchleppDown", mode = "v" },
      { "h", "<Plug>SchleppLeft", mode = "v" },
      { "l", "<Plug>SchleppRight", mode = "v" },
      { "<S-up>", "<Plug>SchleppIndentUp", mode = "v" },
      { "<S-down>", "<Plug>SchleppIndentDown", mode = "v" },
      { "D", "<Plug>SchleppDup", mode = "v" },
      { "Dk", "<Plug>SchleppDupUp", mode = "v" },
      { "Dj", "<Plug>SchleppDupDown", mode = "v" },
      { "Dh", "<Plug>SchleppDupLeft", mode = "v" },
      { "Dl", "<Plug>SchleppDupRight", mode = "v" },
    },
  },
}
