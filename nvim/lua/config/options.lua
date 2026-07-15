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

-- Highlight
opt.cursorline = true

-- Indentation
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true

-- Tweaks
opt.previewheight = 1
opt.ignorecase = true
opt.smartcase = true
opt.confirm = true
opt.showmatch = true
opt.autowrite = true
opt.switchbuf = "useopen,usetab"
opt.title = true
opt.titleold = ""
opt.more = false
opt.updatecount = 10
opt.updatetime = 250
opt.timeoutlen = 500
opt.ttimeoutlen = 0
-- Folding
opt.foldnestmax = 20

-- Persistent undo
local backupdir = vim.fn.stdpath("data") .. "/backups"
local undodir = vim.fn.stdpath("data") .. "/undo"
local swapdir = vim.fn.stdpath("data") .. "/swap"
vim.fn.mkdir(backupdir, "p")
vim.fn.mkdir(undodir, "p")
vim.fn.mkdir(swapdir, "p")
opt.undodir = undodir
opt.backupdir = backupdir
opt.directory = swapdir
opt.undofile = true
opt.swapfile = true
opt.backup = true
opt.writebackup = true
opt.sessionoptions:remove({ "blank", "help" })

-- Display
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", extends = "❯", precedes = "❮" }

-- Completion
opt.wildignore:append("*.o,*.obj,*~,*vim/backups*,*DS_Store*,*.png,*.jpg,*.gif,*/tmp/*,*.so,*.swp,*.pcap,*.pyc,*.cmd,*.a,*.jar")

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 15
opt.wrap = false
opt.linebreak = true

-- Popup menu
opt.pumheight = 15

-- Completion sources
opt.complete:append({ "k", "kspell", "s" })

-- Spell
opt.spelllang = "en_us"

-- Indent after break
opt.breakindent = true

-- Pattern memory
opt.maxmempattern = 10000

-- Sign column
opt.signcolumn = "yes"

-- Completion menu
opt.completeopt = "menu,menuone,noselect"
