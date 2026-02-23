# Dotfiles

### My dotfiles, crafted with ❤️

This repository is a [NixOS flake](https://nixos.wiki/wiki/Flakes) that manages
both the system configuration and user environment via
[home-manager](https://github.com/nix-community/home-manager).

The following dependencies are needed to use all features from this dotfile
repository:

- **Desktop**:
  - [alacritty](https://github.com/jwilm/alacritty):
    A cross-platform, GPU-accelerated terminal emulator
  - [arc](https://github.com/NicoHood/arc-theme):
    The GTK theme
  - [bibata](https://github.com/KaizIqbal/Bibata_Cursor):
    Beatiful cursor theme
  - [picom](https://github.com/yshui/picom):
    A compositor for X11
  - [dunst](https://github.com/dunst-project/dunst):
    Lightweight and customizable notification daemon
  - [feh](https://github.com/derf/feh):
    A fast and light image viewer
  - [i3](https://github.com/i3/i3):
    A tiling window manager
  - [i3status-rust](https://github.com/greshake/i3status-rust):
    A replacement for i3status
  - [ibus](https://github.com/ibus/ibus):
    Intelligent Input Bus
  - [j4-dmenu](https://github.com/enkore/j4-dmenu-desktop):
    The desktop menu
  - [nerd-fonts](https://github.com/ryanoasis/nerd-fonts):
    Iconic fonts (managed via NixOS packages)
  - [networkManager](https://github.com/NetworkManager/NetworkManager):
    For managing network connections
  - [papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme):
    The icon theme
  - [x11](https://www.x.org):
    Windowing system
- **Vim**:
  - [alex](https://github.com/get-alex/alex):
    Needed for ALE Markdown/asciidoc linting and fixing
  - [cscope](http://cscope.sourceforge.net):
    Tool for source code indexing and querying
  - [ctags](http://ctags.sourceforge.net):
    Generates tags file for source code discovery
  - [floskell](https://github.com/ennocramer/floskell):
    Needed for ALE Haskell linting and fixing
  - [node](https://github.com/nodejs/node):
    Needed for YouCompleteMe typescript/javascript support
  - [npm](https://github.com/npm/cli):
    Needed for YouCompleteMe typescript/javascript support
  - [autopep8](https://github.com/hhatto/autopep8):
    Needed for ALE python linting and fixing
  - [clang-format](https://github.com/llvm-mirror/clang/tree/master/tools/clang-format):
    Needed for ALE C/C++ linting and fixing
  - [golangci-lint](https://github.com/golangci/golangci-lint):
    Needed for ALE golang linting and fixing
  - [hdevtools](https://github.com/hdevtools/hdevtools):
    Needed for ALE haskell linting and fixing
  - [hfmt](https://github.com/danstiner/hfmt):
    Needed for ALE haskelllinting and fixing
  - [hlint](https://github.com/ndmitchell/hlint):
    Needed for ALE haskelllinting and fixing
  - [isort](https://github.com/timothycrosley/isort):
    Needed for ALE python linting and fixing
  - [prettier](https://github.com/prettier/prettier):
    Needed for general ALE linting and fixing
  - [proselint](https://github.com/amperser/proselint):
    Needed for ALE Markdown/asciidoc linting and fixing
  - [rls](https://github.com/rust-lang/rls):
    Needed for ALE rust linting and fixing
  - [rustfmt](https://github.com/rust-lang/rustfmt):
    Needed for ALE rust code formatting
  - [shellcheck](https://github.com/koalaman/shellcheck):
    Needed for ALE bash/sh linting and fixing
  - [shfmt](https://github.com/mvdan/sh):
    Needed for ALE bash/sh linting and fixing
  - [textlint](https://github.com/textlint/textlint):
    Needed for ALE Markdown/asciidoc linting and fixing
  - [tflint](https://github.com/wata727/tflint):
    Needed for ALE terraform linting and fixing
  - [write-good](https://github.com/btford/write-good):
    Needed for ALE Markdown/asciidoc linting and fixing
  - [yapf](https://github.com/google/yapf):
    Needed for ALE python linting and fixing
  - [yamllint](https://github.com/adrienverge/yamllint):
    Needed for ALE yaml linting and fixing
- **Development**:
  - [autojump](https://github.com/wting/autojump):
    A cd command that learns
  - [bat](https://github.com/sharkdp/bat):
    Like `cat` with wings
  - [ccache](https://github.com/ccache/ccache):
    Compiler cache for gcc and clang
  - [cht.sh](https://github.com/chubin/cheat.sh):
    Command line stackoverflow queries
  - [claude](https://github.com/anthropics/claude-code):
    Anthropic's official CLI for Claude AI
  - [clang](https://github.com/llvm-mirror/clang):
    The LLVM compiler frontend
  - [cmake](https://github.com/Kitware/CMake):
    Cross platform make tool
  - [cppcheck](https://github.com/danmar/cppcheck):
    Linter for C/C++ projects
  - [cpplint](https://github.com/cpplint/cpplint):
    Linter for C/C++ projects
  - [eza](https://github.com/eza-community/eza):
    Modern version of `ls`
  - [fd](https://github.com/sharkdp/fd):
    A fast alternative to `find`
  - [fish](https://github.com/fish-shell/fish-shell):
    The interactive shell
  - [fzf](https://github.com/junegunn/fzf):
    Command line fuzzy finder
  - [gdb](https://www.gnu.org/s/gdb):
    The debugger for various kind of projects
  - [ghc](https://github.com/ghc/ghc):
    The glasgow haskell compiler
  - [git](https://github.com/git/git):
    Revision control system
  - [golang](https://github.com/golang):
    The go programminng language
  - [htop](https://github.com/hishamhm/htop):
    Process manager for the terminal
  - [nix](https://nixos.org/nix):
    A powerful functional package manager
  - [nixos](https://nixos.org):
    Linux distribution built on Nix package manager
  - [osc](https://github.com/openSUSE/osc):
    Command Line Interface to work with an Open Build Service
  - [python](https://github.com/python):
    The python scripting language
  - [rainbarf](https://github.com/creaktive/rainbarf):
    CPU/RAM/battery stats chart bar for tmux
  - [ranger](https://github.com/ranger/ranger):
    VIM-inspired filemanager for the console
  - [ripgrep](https://github.com/BurntSushi/ripgrep):
    Recursively searches directories for a regex pattern
  - [rust](https://github.com/rust-lang/rust):
    The rust programming language
  - [rustup](https://github.com/rust-lang/rustup.rs):
    Rust toolchain and component management
  - [stack](https://github.com/commercialhaskell/stack):
    The haskell tool stack
  - [tig](https://www.openssh.com):
    Command line git explorer
  - [tmux](https://github.com/tmux/tmux):
    Terminal multiplexer
  - [tokei](https://github.com/Aaronepower/tokei):
    Count lines of code quickly
  - [typos](https://github.com/crate-ci/typos):
    Source code spell checker
  - [vim](https://github.com/vim):
    The editor

## Installation

```fish
> git clone https://github.com/saschagrunert/dotfiles ~/.dotfiles
> cd ~/.dotfiles
> make gitconfig-user USER="John Doe" EMAIL="john@doe.com" SIGNKEY="123"
> sudo ln -sfn ~/.dotfiles /etc/nixos
> sudo nixos-rebuild switch --flake ~/.dotfiles#nixos
```

The `gitconfig-user` target creates `~/.gitconfig_user` with your name, email
and GPG signing key.

## Rebuilding

After editing any configuration file, rebuild with:

```fish
> make switch
```

Or use the `up` alias which also updates Rust, collects garbage and
pre-caches the dev shell.

## Updating

To update flake inputs (nixpkgs, home-manager) to their latest versions:

```fish
> nix flake update --flake ~/.dotfiles
> make switch
```

To pull the latest dotfiles and update external dependencies:

```fish
> make upgrade
```

### Vim

To install all necessary vim plugins you need to run `:PlugInstall` on initial
startup of vim. To update them run `:PlugUpdate` or `:PlugUpdate!`.

The following vim plugins are available via these dotfiles:

- [abolish](https://github.com/tpope/vim-abolish):
  Easily search for, substitute, and abbreviate multiple variants of a word
- [airline](https://github.com/vim-airline/vim-airline):
  Statusline enhancements
- [ale](https://github.com/dense-analysis/ale):
  Asynchronous linter and fixer
- [auto-pairs](https://github.com/jiangmiao/auto-pairs):
  Insert or delete brackets, parens, quotes in pair
- [bpftrace](https://github.com/mmarchini/bpftrace.vim):
  BPFtrace syntax highlighting
- [capnp](https://github.com/cstrahan/vim-capnp):
  Cap'n Proto syntax highlighting
- [characterize](https://github.com/tpope/vim-characterize):
  Unicode character metadata
- [commentary](https://github.com/tpope/vim-commentary):
  Easy commenting
- [ctrlp](https://github.com/ctrlpvim/ctrlp.vim):
  Fuzzy file, buffer, mru, tag, etc finder.
- [devicons](https://github.com/ryanoasis/vim-devicons):
  Unicode characters for nerds
- [dracula](https://github.com/saschagrunert/dracula):
  Modified variant of the dracula color scheme
- [easymotion](https://github.com/easymotion/vim-easymotion):
  Efficient movements
- [endwise](https://github.com/tpope/vim-endwise):
  Wisely add endings
- [eunuch](https://github.com/tpope/vim-eunuch):
  Helpers for unix
- [exchange](https://github.com/tommcdo/vim-exchange):
  Easy text exchange operator
- [fish](https://github.com/dag/vim-fish):
  Fish shell syntax
- [fugitive](https://github.com/tpope/vim-fugitive):
  Git on steroids
- [git](https://github.com/tpope/vim-git):
  Git syntax and definitions
- [gitgutter](https://github.com/airblade/vim-gitgutter):
  Git diff in sign column
- [go](https://github.com/fatih/vim-go):
  Enhancements for golang
- [haskell](https://github.com/neovimhaskell/haskell-vim):
  Haskell syntax and definitions
- [javascript](https://github.com/pangloss/vim-javascript):
  JavaScript syntax and definitions
- [jsonnet](https://github.com/google/vim-jsonnet):
  Jsonnet syntax and definitions
- [markdown](https://github.com/tpope/vim-markdown):
  Markdown syntax and definitions
- [nix](https://github.com/LnL7/vim-nix):
  Nix syntax and definitions
- [operator-user](https://github.com/kana/vim-operator-user):
  Define your own operator easily
- [repeat](https://github.com/tpope/vim-repeat):
  Enable repeating supported plugin maps
- [ripgrep](https://github.com/jremmen/vim-ripgrep):
  Ripgrep search helper
- [rust](https://github.com/rust-lang/rust.vim):
  Rust syntax and definitions
- [schlepp](https://github.com/zirrostig/vim-schlepp):
  Easily moving text selections around
- [scriptease](https://github.com/tpope/vim-scriptease):
  A Vim plugin for Vim plugins
- [shakespeare](https://github.com/pbrisbin/vim-syntax-shakespeare):
  Shakespeare template syntax highlighting
- [snippets](https://github.com/honza/vim-snippets):
  Snippets for ultisnips
- [speeddating](https://github.com/tpope/vim-speeddating):
  Use CTRL-A/CTRL-X to increment dates, times, and more
- [surround](https://github.com/tpope/vim-surround):
  Quoting/parenthesizing made simple
- [tabular](https://github.com/godlygeek/tabular):
  Text filtering and alignment
- [tagbar](https://github.com/majutsushi/tagbar):
  Sidebar for tags
- [terraform](https://github.com/hashivim/vim-terraform):
  Terraform syntax and definitions
- [targets](https://github.com/wellle/targets.vim):
  Additional text objects
- [textobj-comment](https://github.com/glts/vim-textobj-comment):
  Textobject enhancement for comments
- [textobj-lastpat](https://github.com/kana/vim-textobj-lastpat):
  Textobject enhancement for last searched patterns
- [textobj-user](https://github.com/kana/vim-textobj-user):
  Enables custom textobjects
- [textobj-variable-segment](https://github.com/Julian/vim-textobj-variable-segment):
  Textobject enhancement for variables
- [tmux-navigator](https://github.com/christoomey/vim-tmux-navigator):
  Seamlessly switch between tmux panes and vim
- [tmuxline](https://github.com/edkolev/tmuxline.vim):
  Tmux status line modding
- [toml](https://github.com/cespare/vim-toml):
  TOML syntax and definitions
- [typescript](https://github.com/leafgarland/typescript-vim):
  Typescript syntax and definitions
- [ultisnips](https://github.com/SirVer/ultisnips):
  Snipped engine
- [undotree](https://github.com/mbbill/undotree):
  Graphica undo list representation
- [unimpaired](https://github.com/tpope/vim-unimpaired):
  Pairs of handy bracket mappings
- [ycm-generator](https://github.com/rdnetto/YCM-Generator):
  Generate YouCompleteMe configuration files
- [youcompleteme](https://github.com/Valloric/YouCompleteMe):
  Autocompletion for multiple languages

## Screenshots

![vim screenshot](.github/vim.png "Vim")
![alacritty screenshot](.github/alacritty.png "Alacritty")

## Contributing

You want to contribute to this project? Wow, thanks! So please just fork it and
submit a pull request.
