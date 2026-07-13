# Dotfiles

## My dotfiles, crafted with ❤️

This repository is a [NixOS flake](https://nixos.wiki/wiki/Flakes) that manages
both the system configuration and user environment via
[home-manager](https://github.com/nix-community/home-manager).

## Key Components

- **Desktop**:
  - [alacritty](https://github.com/alacritty/alacritty):
    A cross-platform, GPU-accelerated terminal emulator
  - [arc](https://github.com/NicoHood/arc-theme):
    The GTK theme (managed via home-manager)
  - [bibata](https://github.com/ful1e5/Bibata_Cursor):
    Beautiful cursor theme (managed via home-manager)
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
    The icon theme (managed via home-manager)
  - [x11](https://www.x.org):
    Windowing system
- **Neovim** (managed via [lazy.nvim](https://github.com/folke/lazy.nvim)):
  - Native LSP via [mason.nvim](https://github.com/williamboman/mason.nvim) +
    [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  - Completion via [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) +
    [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
  - Formatting via [conform.nvim](https://github.com/stevearc/conform.nvim)
  - Linting via [nvim-lint](https://github.com/mfussenegger/nvim-lint)
  - Syntax via [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
  - Fuzzy finding via [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
  - Git via [fugitive](https://github.com/tpope/vim-fugitive) +
    [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
  - Theme: [dracula.nvim](https://github.com/Mofiqul/dracula.nvim)
- **Development**:
  - [bat](https://github.com/sharkdp/bat):
    Like `cat` with wings
  - [claude](https://github.com/anthropics/claude-code):
    Anthropic's official CLI for Claude AI
  - [clang](https://github.com/llvm/llvm-project):
    The LLVM compiler frontend
  - [delta](https://github.com/dandavison/delta):
    A syntax-highlighting pager for git
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
  - [git](https://github.com/git/git):
    Revision control system
  - [golang](https://go.dev):
    The Go programming language
  - [htop](https://github.com/hishamhm/htop):
    Process manager for the terminal
  - [nix](https://nixos.org/nix):
    A powerful functional package manager
  - [nixos](https://nixos.org):
    Linux distribution built on Nix package manager
  - [python](https://python.org):
    The Python scripting language
  - [ranger](https://github.com/ranger/ranger):
    VIM-inspired filemanager for the console
  - [ripgrep](https://github.com/BurntSushi/ripgrep):
    Recursively searches directories for a regex pattern
  - [rustup](https://github.com/rust-lang/rustup):
    Rust toolchain and component management
  - [tig](https://github.com/jonas/tig):
    Command line git explorer
  - [tmux](https://github.com/tmux/tmux):
    Terminal multiplexer
  - [typos](https://github.com/crate-ci/typos):
    Source code spell checker
  - [neovim](https://github.com/neovim/neovim):
    The editor
  - [zoxide](https://github.com/ajeetdsouza/zoxide):
    A smarter cd command

See [`nixos/packages.nix`](nixos/packages.nix) for the full list of installed
packages, including container runtimes, Kubernetes tools, networking utilities,
and debugging tools.

## Structure

```text
flake.nix                      # Nix flake entry point
home.nix                       # Home-manager user config
nixos/
├── configuration.nix          # Main NixOS config
├── hosts/
│   └── desktop/               # Machine-specific config
│       ├── default.nix        # Host imports
│       ├── hardware.nix       # Filesystems, kernel modules
│       └── boot.nix           # Bootloader, initrd, kernel
├── packages.nix               # System packages
├── packages/                  # Custom package derivations
│   └── usbip-host-patched.nix # Patched usbip kernel module
├── patches/                   # Kernel patches
├── programs.nix               # fish, neovim, gnupg, ...
├── virtualisation.nix         # docker, podman, cri-o
├── services.nix               # X11, i3, pipewire, ...
├── network.nix                # Hostname, NetworkManager
├── security.nix               # Kerberos, PKI, sudo
├── users.nix                  # User accounts, groups, shell
├── locale.nix                 # Locale, input method
├── fonts.nix                  # Nerd Fonts, Roboto, ...
└── setup-screens.nix          # Monitor & wallpaper setup
```

To add a new host, create a directory under `nixos/hosts/` with its own
`hardware.nix` and `boot.nix`, then add a new `nixosConfigurations` entry
in `flake.nix`.

## Installation

```fish
> git clone https://github.com/saschagrunert/dotfiles ~/.dotfiles
> cd ~/.dotfiles
> make gitconfig-user USER="John Doe" EMAIL="john@doe.com" SIGNKEY="123"
> sudo nixos-rebuild switch --flake ~/.dotfiles#nixos
```

The `gitconfig-user` target creates `~/.gitconfig_user` with your name, email
and GPG signing key.

## Rebuilding

After editing any configuration file, rebuild with:

```fish
> make switch
```

Or use the `up` abbreviation which also updates Rust, collects garbage
and pre-caches the dev shell.

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

### Neovim

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and
install automatically on first launch. LSP servers are installed via
[Mason](https://github.com/williamboman/mason.nvim) on first use.

## Contributing

You want to contribute to this project? Wow, thanks! So please just fork it and
submit a pull request.
