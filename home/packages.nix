{ pkgs, ... }:
{
  # Packages that only the user session needs. Keeping them out of
  # environment.systemPackages means adding an editor plugin, a language server
  # or a CLI tool no longer rebuilds and activates the system closure.
  # Anything root runs (toolchains used through sudo, container and networking
  # tools, kernel utilities) stays in nixos/packages.nix.
  home.packages = with pkgs; [
    # Desktop & UI
    alacritty
    fuzzel
    google-chrome
    grim
    libnotify
    mako
    networkmanagerapplet
    pavucontrol
    piper
    slurp
    wdisplays
    wl-clipboard
    xdg-utils

    # System utilities
    bat
    btop
    calc
    eza
    fd
    file
    fzf
    jq
    ripgrep
    tmux
    unzip
    wget
    yazi
    zoxide

    # Development tools
    claude-code
    delta
    gh
    jira-cli-go
    lazygit
    tree-sitter

    # LSP servers
    bash-language-server
    buf
    lua-language-server
    nil
    pyright
    taplo
    vscode-langservers-extracted
    vtsls
    yaml-language-server

    # Language tooling. The compilers themselves stay system-wide, since
    # sudo-driven builds (see fish/functions/kubernetes.fish) need them.
    llvmPackages_22.clang-tools
    gofumpt
    golangci-lint
    gopls
    gotools
    nodejs
    prettier
    python3Packages.osc
    ruff
    rustup

    # Cloud
    cosign
    google-cloud-sdk

    # Code quality & linting. Also used by conform.nvim and nvim-lint, which
    # resolve them from PATH. The Makefile targets deliberately fetch their own
    # copies through the flake, so CI does not depend on this list.
    deadnix
    nixfmt
    shellcheck
    shfmt
    statix
    stylua
    typos
    yamllint

    # Media & documents, mostly yazi previewers
    exiftool
    imagemagick
    libarchive
    mediainfo
    wf-recorder

    # Nix tools
    cachix
    nix-index
  ];
}
