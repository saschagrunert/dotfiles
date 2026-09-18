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
  [fzf-lua](https://github.com/ibhagwan/fzf-lua),
  [dracula.nvim](https://github.com/Mofiqul/dracula.nvim).
- **Shell and tools**: [fish](https://github.com/fish-shell/fish-shell),
  [tmux](https://github.com/tmux/tmux),
  [git](https://github.com/git/git) +
  [delta](https://github.com/dandavison/delta) +
  [lazygit](https://github.com/jesseduffield/lazygit),
  [yazi](https://github.com/sxyazi/yazi),
  [fzf](https://github.com/junegunn/fzf),
  [zoxide](https://github.com/ajeetdsouza/zoxide),
  [ripgrep](https://github.com/BurntSushi/ripgrep).

See [`home/packages.nix`](home/packages.nix) for the user session packages
(desktop apps, CLI tools, language servers, linters) and
[`nixos/packages.nix`](nixos/packages.nix) for what root and the system
services need (toolchains, container runtimes, networking and debugging tools).

## Structure

```text
flake.nix                      # Nix flake entry point
shells.nix                     # Dev shells (base + per-project)
home.nix                       # Home-manager user config
Makefile                       # Build, lint, test
.editorconfig                  # Indentation, shared by shfmt and prettier
alacritty/                     # Terminal emulator config
bat/                           # Syntax highlighting config
btop/                          # System monitor config
clang/                         # Clang-format config
claude/                        # Claude Code settings and instructions
fish/                          # Shell config, functions, theme
fuzzel/                        # Application launcher config
git/                           # gitconfig, gitignore
home/
└── packages.nix               # User session packages
lazygit/                       # Git TUI config
mako/                          # Notification daemon config
nvim/                          # Neovim config (lazy.nvim plugins)
rustfmt/                       # Rust formatter config
sway/
├── config                     # Sway compositor config
└── workspace-scroll           # Workspace scroll helper
tmux/                          # Terminal multiplexer config
wallpaper/                     # Desktop wallpapers
yazi/                          # File manager config and theme
waybar/
├── config.jsonc               # Waybar module config
├── style.css                  # Waybar styling
├── dnd                        # Do-not-disturb toggle
├── failed-units               # Failed systemd units indicator
├── fans                       # Fan speed monitor
├── gpu                        # GPU load and VRAM monitor
├── hwmon.sh                   # Shared hwmon lookup for fans/gpu/power/temps
├── power                      # Power consumption monitor
└── temps                      # Hardware temperature monitor
nixos/
├── configuration.nix          # Main NixOS config
├── desktop.nix                # Sway, Wayland env, polkit agent
├── hosts/
│   └── desktop/               # Machine-specific config
│       ├── default.nix        # Host imports
│       ├── hardware.nix       # Filesystems, swap
│       └── boot.nix           # Bootloader, initrd, kernel modules
├── packages.nix               # System packages (root and services)
├── programs.nix               # fish, neovim, gnupg, direnv, ...
├── virtualisation.nix         # podman, cri-o, libvirtd
├── services.nix               # greetd, pipewire, openssh, ...
├── network.nix                # Hostname, NetworkManager
├── security.nix               # Kerberos, PKI, sudo
├── users.nix                  # User accounts, groups, shell
├── locale.nix                 # Locale, timezone
└── fonts.nix                  # Nerd Fonts, Roboto, ...
```

Packages are split in two: `nixos/packages.nix` holds what root and the system
services need (toolchains used through `sudo`, container and networking tools),
`home/packages.nix` holds the user session. Changing the latter does not rebuild
the system closure.

To add a new host, create a directory under `nixos/hosts/` with its own
`hardware.nix` and `boot.nix`, then add a new `nixosConfigurations` entry in
`flake.nix`. The machine-specific parts of `sway/config` (outputs, workspace
mapping, input devices) are marked with comments.

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
> make test     # all lint and format checks, see `make help`
> make check    # verify symlinks and required commands on a switched system
> make smoke    # run the waybar status scripts and validate their JSON
> make lint     # nixfmt, statix, deadnix
```

`make test` does not build anything. Use `make build` to check that the
configuration still builds, or `make switch` to apply it. CI runs every `make
test` target plus `make build`, so a package that stopped building on
nixpkgs-unstable fails in a pull request instead of at switch time.

Or use the `up` function which also updates Rust and collects garbage.

## Updating

To update flake inputs (nixpkgs, home-manager) to their latest versions:

```fish
> nix flake update --flake ~/.dotfiles
> make switch
```

This also happens weekly in CI: `.github/workflows/update.yml` runs
`nix flake update`, then `make test` and `make build`, and opens a pull request
only if both pass. It has to verify everything itself, because a pull request
opened with `GITHUB_TOKEN` does not trigger the test workflow. Dependabot keeps
the GitHub Actions up to date.

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
install automatically on first launch. LSP servers, formatters and linters are
installed as Nix packages via `home/packages.nix`, and resolved from `PATH` by
`nvim-lspconfig`, `conform.nvim` and `nvim-lint`.

## Contributing

You want to contribute to this project? Wow, thanks! So please just fork it and
submit a pull request.
