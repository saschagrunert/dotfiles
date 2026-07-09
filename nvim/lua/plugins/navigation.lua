return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          jump_labels = true,
        },
        search = {
          enabled = false,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end },
      { "r", mode = "o", function() require("flash").remote() end },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end },
    },
  },
}
