" Use Vim settings, rather than Vi.
set nocompatible

" detect current file type
filetype plugin indent on

" Change leader to a space because the backslash is too far away
let mapleader="\<Space>"
let maplocalleader="\,"

set shell=bash
set shortmess=I

" set language
let os=substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac' || os == 'FreeBSD'
    language en_US.UTF-8
elseif os == 'Linux'
    language en_US.utf8
    set clipboard=unnamedplus
endif

" show line numbers
set number

set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history

" highlight current line and column
set cursorline

" idendation
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround
set autoindent
set smarttab

" some tweaks
set previewheight=1
set ruler
set hidden
set showcmd
set hlsearch
set ignorecase
set smartcase
set nostartofline
set laststatus=2
set confirm
set incsearch
set showmatch
set showmode
set autoread
set autowrite
set lazyredraw
set magic
set switchbuf=useopen,usetab
set title
set titleold=
set nomore
set updatecount=10
set updatetime=250
set timeout
set timeoutlen=2000
set ttimeoutlen=0
set formatoptions+=j

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 50 files
"           | |   +--Remember up to 10000 lines in each register
"           | |   |      +--Remember up to 1MB in each register
"           | |   |      |     +--Remember last 1000 search patterns
"           | |   |      |     |     +---Remember last 1000 commands
"           | |   |      |     |     |
"           v v   v      v     v     v
set viminfo=h,'50,<10000,s1000,/1000,:1000

" no annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Folding
set foldnestmax=20
set nofoldenable

" Persistent Undo
" Keep undo history across sessions, by storing in file.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set backupdir=~/.vim/backups
set dir=/tmp
set undofile
set swapfile
set backup
set encoding=utf8
set writebackup
set sessionoptions-=blank,help

" Display tabs and trailing spaces visually
set list listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮

" Completion
set wildmenu
set wildignore=*.o,*.obj,*~,*vim/backups*,*DS_Store*,*.png,*.jpg,*.gif,*/tmp/*,*.so,*.swp,*.pcap,*.pyc,*.cmd,*.a,*.jar

" Scrolling
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
set nowrap
set linebreak

" Limit popup menu height
set pumheight=15

" better complete
set complete+=U
set complete+=k
set complete+=kspell
set complete+=s

" spell checking
set nospell
set spelllang=en_us

" activate matchit
runtime macros/matchit.vim

" indent after break
set breakindent

set path+=/usr/local/include

let g:netrw_liststyle=1

set regexpengine=2

" fancy fillchars
set fillchars+=vert:│
