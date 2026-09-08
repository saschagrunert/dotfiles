{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    binutils
    claude-code
    delta
    gh
    git
    gnumake
    jira-cli-go
    lazygit
    tree-sitter

    # LSP servers
    bash-language-server
    lua-language-server
    nil
    pyright
    taplo
    vscode-langservers-extracted
    vtsls
    yaml-language-server

    # Go
    go_1_27
    gofumpt
    golangci-lint
    gopls
    gotools

    # Rust
    rustup

    # Python
    python3
    python3Packages.osc
    ruff

    # Node.js
    nodejs
    prettier

    # C/C++
    clang_22
    llvmPackages_22.clang-tools

    # Containers & virtualization
    cni-plugins
    conmon
    conmon-rs
    cri-tools
    crun
    fuse-overlayfs
    runc
    slirp4netns
    vagrant
    virt-manager

    # Kubernetes & cloud
    cosign
    google-cloud-sdk
    kubernetes

    # Networking & security
    conntrack-tools
    iptables
    openssl
    openvpn
    socat

    # Debugging & profiling
    lm_sensors
    lshw
    usbutils

    # Code quality & linting
    shellcheck
    shfmt
    stylua
    typos
    yamllint

    # Media & documents
    exiftool
    imagemagick
    libarchive
    mediainfo
    wf-recorder

    # Nix tools
    cachix
    deadnix
    nix-index
    nixfmt
    statix

  ];
}
