{ pkgs, dotfilesPath, ... }:
{
  environment.systemPackages = with pkgs; [
    (import ./setup-screens.nix { inherit writeShellScriptBin dotfilesPath; })

    # Desktop & UI
    alacritty
    arandr
    dmenu
    dunst
    feh
    google-chrome
    j4-dmenu-desktop
    lxappearance
    pavucontrol
    xclip
    xdg-utils
    xev
    zoom-us

    # System utilities
    bat
    calc
    eza
    fd
    file
    fzf
    htop
    jq
    parallel
    pstree
    ranger
    ripgrep
    tmux
    unzip
    wget
    yq-go
    zoxide

    # Development tools
    binutils
    claude-code
    cmake
    ctags
    delta
    gcc
    gh
    git
    git-lfs
    gnumake
    graphviz
    rpm
    tig

    # LSP servers
    bash-language-server
    lua-language-server
    nil
    pyright
    rust-analyzer
    terraform-ls
    vtsls
    yaml-language-server

    # Go
    go_1_26
    gofumpt
    golangci-lint
    gopls
    gotools

    # Rust
    cargo-edit
    cargo-watch
    rustup

    # Python
    jira-cli-go
    python3
    python3Packages.autopep8
    python3Packages.isort
    python3Packages.osc

    # Node.js
    nodejs
    prettier

    # C/C++
    clang-tools
    clang_22

    # Containers & virtualization
    cni-plugins
    conmon
    conmon-rs
    cri-tools
    criu
    crun
    fuse-overlayfs
    oras
    runc
    skopeo
    slirp4netns
    vagrant
    virt-manager

    # Kubernetes & cloud
    cosign
    google-cloud-sdk
    kind
    kubernetes
    kustomize

    # Serialization & data
    buf
    capnproto
    protobuf
    protolint

    # Networking & security
    cfssl
    conntrack-tools
    inetutils
    iptables
    jwt-cli
    ldns
    openssl
    openvpn
    socat
    unixtools.netstat

    # Debugging & profiling
    bpftools
    gdb
    heaptrack
    libcgroup
    lm_sensors
    lshw
    lvm2
    pahole
    usbutils
    valgrind

    # Code quality & linting
    bats
    ginkgo
    proselint
    shellcheck
    shfmt
    typos
    yamllint

    # Head tracking
    opentrack

    # Media & documents
    asciinema
    imagemagick
    kooha
    mediainfo

    # Nix tools
    cachix
    nix-index
    nix-prefetch-git
    nixfmt
    nixos-shell

    # Misc
    bom
    perlPackages.Apprainbarf
  ];
}
