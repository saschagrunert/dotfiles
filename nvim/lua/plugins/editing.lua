return {
  { "tpope/vim-surround", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "tpope/vim-abolish",
    event = "VeryLazy",
    config = function()
      local abbreviations = {
        { "exlude", "exclude" },
        { "retrun", "return" },
        { "pritn", "print" },
        { "teh", "the" },
        { "liek", "like" },
        { "liekwise", "likewise" },
        { "moer", "more" },
        { "lenght", "length" },
        { "afterword{,s}", "afterward{}" },
        { "anomol{y,ies}", "anomal{}" },
        { "austrail{a,an,ia,ian}", "austral{ia,ian}" },
        { "cal{a,e}nder{,s}", "cal{e}ndar{}" },
        { "{c,m}arraige{,s}", "{}arriage{}" },
        { "{,in}consistan{cy,cies,t,tly}", "{}consisten{}" },
        { "delimeter{,s}", "delimiter{}" },
        { "{,non}existan{ce,t}", "{}existen{}" },
        { "despara{te,tely,tion}", "despera{}" },
        { "d{e,i}screp{e,a}nc{y,ies}", "d{i}screp{a}nc{}" },
        { "euphamis{m,ms,tic,tically}", "euphemis{}" },
        { "hense", "hence" },
        { "{,re}impliment{,s,ing,ed,ation}", "{}implement{}" },
        { "improvment{,s}", "improvement{}" },
        { "inherant{,ly}", "inherent{}" },
        { "lastest", "latest" },
        { "{les,compar,compari}sion{,s}", "{les,compari,compari}son{}" },
        { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" },
        { "{,un}orgin{,al}", "{}origin{}" },
        { "persistan{ce,t,tly}", "persisten{}" },
        { "referesh{,es}", "refresh{}" },
        { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" },
        { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" },
        { "reproducable", "reproducible" },
        { "resouce{,s}", "resource{}" },
        { "restraunt{,s}", "restaurant{}" },
        { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" },
        { "segument{,s,ed,ation}", "segment{}" },
        { "Tqbf", "The quick brown fox jumps over the lazy dog." },
        { "Lipsum", "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." },
      }
      for _, pair in ipairs(abbreviations) do
        vim.cmd("Abolish " .. pair[1] .. " " .. pair[2])
      end
    end,
  },
  { "tpope/vim-eunuch", cmd = { "Remove", "Rename", "Mkdir", "Move", "Chmod", "SudoWrite", "SudoEdit", "Wall" } },
  { "tommcdo/vim-exchange", keys = { "cx", { "X", mode = "v" } } },
  {
    "tpope/vim-speeddating",
    keys = { "<C-a>", "<C-x>" },
    config = function()
      vim.cmd("SpeedDatingFormat %d.%m.%y")
      vim.cmd("SpeedDatingFormat %d.%m.%Y")
      vim.cmd("SpeedDatingFormat %d/%m/%y")
      vim.cmd("SpeedDatingFormat %d/%m/%Y")
      vim.cmd("SpeedDatingFormat %d-%m-%y")
      vim.cmd("SpeedDatingFormat %d-%m-%Y")
    end,
  },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "wellle/targets.vim", event = "VeryLazy" },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
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
