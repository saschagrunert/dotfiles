return {
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
    },
  },
  {
    "edkolev/tmuxline.vim",
    event = "VimEnter",
    cmd = { "Tmuxline", "TmuxlineSnapshot" },
    cond = function() return vim.env.TMUX ~= nil end,
    init = function()
      local s = "~/.tmux/scripts"
      vim.g.tmuxline_preset = {
        a = "#{?client_prefix,[PREFIX] - ,}#S",
        b = "#F",
        c = {
          "#(" .. s .. "/pwd)",
          "#(" .. s .. "/branch)#(" .. s .. "/modified)#(" .. s .. "/staged)#(" .. s .. "/stashed)#(" .. s .. "/compare) #(" .. s .. "/rainbarf)#[fg=#44475a,bg=#44475a]",
        },
        win = { "#I", "#W" },
        cwin = { "#I", "#W" },
        x = { "#(" .. s .. "/ip)" },
        y = { "%a", "%d. %b", "%R" },
        z = { "  #H" },
      }
    end,
    config = function()
      vim.fn["tmuxline#api#set_theme"]({
        a = { "#282a36", "#bd93f9", "" },
        b = { "#f8f8f2", "#6272a4", "" },
        c = { "#f8f8f2", "#44475a", "" },
        bg = { "#282a36", "#282a36", "" },
        cwin = { "#282a36", "#50fa7b", "" },
        win = { "#f8f8f2", "#282a36", "" },
        x = { "#f8f8f2", "#44475a", "" },
        y = { "#f8f8f2", "#6272a4", "" },
        z = { "#282A36", "#BD93F9", "" },
      })
    end,
  },
}
