# Dotfiles

## My dotfiles, crafted with ❤️

This repository is a [NixOS flake](https://nixos.wiki/wiki/Flakes) that manages
both the system configuration and user environment via
[home-manager](https://github.com/nix-community/home-manager).

## Key Components

- **Desktop**: [sway](https://github.com/swaywm/sway) (Wayland compositor),
  [waybar](https://github.com/Alexays/Waybar),
  [alacritty](https://github.com/alacritty/alacritty),
  [mako](https://github.com/emersion/mako),
  [fuzzel](https://codeberg.org/dnkl/fuzzel).
  Themed with [dracula](https://github.com/dracula/gtk) (GTK),
  [bibata](https://github.com/ful1e5/Bibata_Cursor) (cursor),
  [papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) (icons).
- **Editor**: [neovim](https://github.com/neovim/neovim) with
  [lazy.nvim](https://github.com/folke/lazy.nvim),
  native LSP, [blink.cmp](https://github.com/Saghen/blink.cmp),
  [conform.nvim](https://github.com/stevearc/conform.nvim),
  [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter),
  [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim),
  [dracula.nvim](https://github.com/Mofiqul/dracula.nvim).
- **Shell and tools**: [fish](https://github.com/fish-shell/fish-shell),
  [tmux](https://github.com/tmux/tmux),
  [git](https://github.com/git/git) + [delta](https://github.com/dandavison/delta),
  [ranger](https://github.com/ranger/ranger),
  [fzf](https://github.com/junegunn/fzf),
  [zoxide](https://github.com/ajeetdsouza/zoxide),
  [ripgrep](https://github.com/BurntSushi/ripgrep).

See [`nixos/packages.nix`](nixos/packages.nix) for the full list of installed
packages, including container runtimes, Kubernetes tools, networking utilities,
and debugging tools.

## Structure

```text
flake.nix                      # Nix flake entry point
shells.nix                     # Dev shells (base + per-project)
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
├── dnd                        # Do-not-disturb toggle
├── power                      # Power consumption monitor
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
├── desktop.nix                # Sway, XDG portals, greetd
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
> make test     # lint, flake check, markdown, prettier, typos, shfmt, shellcheck
> make check    # verify symlinks and required commands
> make lint     # nixfmt, statix, deadnix
```

Or use the `up` function which also updates Rust and collects garbage.

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

## Development Shells

The flake provides two dev shells via `shells.nix`:

- **default**: Base C development environment (clang, pkg-config, glibc) used by
  the `ns` fish function for ad-hoc commands.
- **project**: Dynamically inherits build dependencies from any project that has
  a `nix/overlay.nix` and `nix/derivation.nix`. Used via
  [direnv](https://direnv.net) with a per-project `.envrc`:

```bash
use flake ~/.dotfiles#project --impure
```

When entering the project directory, direnv automatically activates the shell
with the correct dependencies. The `--impure` flag is required because the
shell reads `$PWD` to locate the project's nix files at evaluation time.

### Neovim

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and
install automatically on first launch. LSP servers are installed as Nix
packages via `nixos/packages.nix`.

## Contributing

You want to contribute to this project? Wow, thanks! So please just fork it and
submit a pull request.
