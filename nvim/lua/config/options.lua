local opt = vim.opt

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Shell
opt.shell = "bash"
opt.shortmess:append("W")

-- Language / clipboard
opt.clipboard = "unnamedplus"

-- Line numbers
opt.number = true

-- Editing
opt.backspace = "indent,eol,start"
opt.history = 1000

-- Highlight
opt.cursorline = true

-- Indentation
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true
opt.autoindent = true
opt.smarttab = true

-- Tweaks
opt.previewheight = 1
opt.ruler = true
opt.showcmd = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.startofline = false
opt.confirm = true
opt.incsearch = true
opt.showmatch = true
opt.autoread = true
opt.autowrite = true
opt.lazyredraw = true
opt.magic = true
opt.switchbuf = "useopen,usetab"
opt.title = true
opt.titleold = ""
opt.more = false
opt.updatecount = 10
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 2000
opt.ttimeoutlen = 0
opt.formatoptions:append("j")

-- No annoying sounds
opt.errorbells = false
opt.visualbell = false

-- Folding
opt.foldnestmax = 20

-- Persistent undo
local backupdir = vim.fn.stdpath("data") .. "/backups"
vim.fn.mkdir(backupdir, "p")
opt.undodir = backupdir
opt.backupdir = backupdir
opt.directory = "/tmp"
opt.undofile = true
opt.swapfile = true
opt.backup = true
opt.writebackup = true
opt.encoding = "utf8"
opt.sessionoptions:remove({ "blank", "help" })

-- Display
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", extends = "❯", precedes = "❮" }

-- Completion
opt.wildmenu = true
opt.wildignore:append("*.o,*.obj,*~,*vim/backups*,*DS_Store*,*.png,*.jpg,*.gif,*/tmp/*,*.so,*.swp,*.pcap,*.pyc,*.cmd,*.a,*.jar")

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 15
opt.sidescroll = 1
opt.wrap = false
opt.linebreak = true

-- Popup menu
opt.pumheight = 15

-- Completion sources
opt.complete:append({ "U", "k", "kspell", "s" })

-- Spell
opt.spell = false
opt.spelllang = "en_us"

-- Indent after break
opt.breakindent = true

-- Path
opt.path:append("/usr/local/include")

-- Netrw
vim.g.netrw_liststyle = 1

-- Markdown fenced code blocks
vim.g.markdown_fenced_languages = {
  "css", "erb=eruby", "javascript", "js=javascript",
  "json=javascript", "ruby", "sass", "xml", "html",
}

-- Fillchars
opt.fillchars:append({ vert = "│" })

-- Pattern memory
opt.maxmempattern = 10000

-- 24-bit color
opt.termguicolors = true

-- Sign column
opt.signcolumn = "yes"

-- Completion menu
opt.completeopt = "menu,menuone,noselect"
