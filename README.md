# Dotfiles

## My dotfiles, crafted with ❤️

This repository is a [NixOS flake](https://nixos.wiki/wiki/Flakes) that manages
both the system configuration and user environment via
[home-manager](https://github.com/nix-community/home-manager).

## Key Components

- **Desktop**:
  - [alacritty](https://github.com/alacritty/alacritty):
    A cross-platform, GPU-accelerated terminal emulator
  - [dracula](https://github.com/dracula/gtk):
    The GTK theme (managed via home-manager)
  - [bibata](https://github.com/ful1e5/Bibata_Cursor):
    Beautiful cursor theme (managed via home-manager)
  - [mako](https://github.com/emersion/mako):
    Lightweight Wayland notification daemon
  - [sway](https://github.com/swaywm/sway):
    A Wayland compositor and tiling window manager
  - [waybar](https://github.com/Alexays/Waybar):
    Highly customizable Wayland bar for sway
  - [fuzzel](https://codeberg.org/dnkl/fuzzel):
    Wayland-native application launcher
  - [nerd-fonts](https://github.com/ryanoasis/nerd-fonts):
    Iconic fonts (managed via NixOS packages)
  - [networkManager](https://github.com/NetworkManager/NetworkManager):
    For managing network connections
  - [papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme):
    The icon theme (managed via home-manager)
- **Neovim** (managed via [lazy.nvim](https://github.com/folke/lazy.nvim)):
  - Native LSP via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    (servers installed as Nix packages)
  - Completion via [blink.cmp](https://github.com/Saghen/blink.cmp) +
    [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
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
Makefile                       # Build, lint, test, upgrade
alacritty/                     # Terminal emulator config
bat/                           # Syntax highlighting themes
clang/                         # Clang-format config
claude/                        # Claude Code settings
fish/                          # Shell config, functions, completions
fuzzel/                        # Application launcher config
gdb/                           # GDB dashboard and init scripts
git/                           # gitconfig, gitignore
htop/                          # Process viewer config
mako/                          # Notification daemon config
nvim/                          # Neovim config (lazy.nvim plugins)
ranger/                        # File manager config and themes
rustfmt/                       # Rust formatter config
sway/
├── config                     # Sway compositor config
├── temps                      # Hardware temperature monitor
└── workspace-scroll           # Workspace scroll helper
tig/                           # Git text-mode interface config
tmux/                          # Terminal multiplexer config
wallpaper/                     # Desktop wallpapers
waybar/
├── config.jsonc               # Waybar module config
└── style.css                  # Waybar styling
nixos/
├── configuration.nix          # Main NixOS config
├── hosts/
│   └── desktop/               # Machine-specific config
│       ├── default.nix        # Host imports
│       ├── hardware.nix       # Filesystems, kernel modules
│       └── boot.nix           # Bootloader, initrd, kernel
├── packages.nix               # System packages
├── programs.nix               # fish, neovim, gnupg, direnv, ...
├── virtualisation.nix         # podman, cri-o, libvirtd
├── services.nix               # Sway, greetd, pipewire, ...
├── network.nix                # Hostname, NetworkManager
├── security.nix               # Kerberos, PKI, sudo
├── users.nix                  # User accounts, groups, shell
├── locale.nix                 # Locale, timezone
└── fonts.nix                  # Nerd Fonts, Roboto, ...
```

To add a new host, create a directory under `nixos/hosts/` with its own
`hardware.nix` and `boot.nix`, then add a new `nixosConfigurations` entry
in `flake.nix`.

## Installation

```fish
> git clone https://github.com/saschagrunert/dotfiles ~/.dotfiles
> cd ~/.dotfiles
> make gitconfig-user GIT_USER="John Doe" EMAIL="john@doe.com" SIGNKEY="123"
> sudo nixos-rebuild switch --flake ~/.dotfiles#nixos
```

The `gitconfig-user` target creates `~/.gitconfig_user` with your name, email
and GPG signing key.

## Rebuilding

After editing any configuration file, rebuild with:

```fish
> make switch
```

To validate the configuration locally:

```fish
> make test     # lint, nix flake check, prettier, typos, shfmt, shellcheck
> make check    # verify symlinks and required commands
> make lint     # nixfmt, statix, deadnix
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
install automatically on first launch. LSP servers are installed as Nix
packages via `nixos/packages.nix`.

## Contributing

You want to contribute to this project? Wow, thanks! So please just fork it and
submit a pull request.
