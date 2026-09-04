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
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shiftround = true

-- Tweaks
opt.previewheight = 5
opt.ignorecase = true
opt.smartcase = true
opt.confirm = true
opt.autowrite = true
opt.switchbuf = "useopen,usetab"
opt.title = true
opt.titleold = ""
opt.more = false
opt.updatetime = 250
opt.timeoutlen = 500
opt.ttimeoutlen = 5
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
opt.backup = true
opt.sessionoptions:remove({ "blank", "help" })

-- Display
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·", extends = "❯", precedes = "❮" }
opt.fillchars = { eob = " ", fold = " ", diff = "╱" }

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 15
opt.wrap = false
opt.smoothscroll = true

-- Splits
opt.splitkeep = "screen"
opt.splitright = true
opt.splitbelow = true

-- Popup menu
opt.pumheight = 15

-- Spell
opt.spelllang = "en_us"

-- Indent after break
opt.breakindent = true

-- Pattern memory
opt.maxmempattern = 10000

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 99

-- Diff
opt.diffopt:append("linematch:60")
opt.diffopt:append("algorithm:histogram")

-- Jump
opt.jumpoptions = "stack"

-- Sign column
opt.signcolumn = "yes"
