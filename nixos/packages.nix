{ config, lib, pkgs, dotfilesPath, ... }:
{
  environment.systemPackages = with pkgs; [
    (import ./setup-screens.nix { inherit writeShellScriptBin dotfilesPath; })

    # Desktop & UI
    acpilight
    alacritty
    arandr
    arc-theme
    autorandr
    dmenu
    dunst
    feh
    google-chrome
    j4-dmenu-desktop
    lxappearance
    pavucontrol
    picom
    xclip
    xev
    xsel

    # System utilities
    autojump
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

    # Development tools
    binutils
    claude-code
    cmake
    ctags
    gcc
    gh
    git
    git-lfs
    gnumake
    graphviz
    tig

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
    python3
    python3Packages.autopep8
    python3Packages.isort
    python3Packages.osc
    python3Packages.yapf

    # Haskell
    haskellPackages.alex

    # Node.js
    nodejs
    nodePackages.prettier

    # C/C++
    clang-tools
    clang_21

    # Containers & virtualization
    buildah
    cni-plugins
    conmon
    conmon-rs
    cri-o
    cri-tools
    criu
    crun
    fuse-overlayfs
    lima
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
    kubectl
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
    sysstat
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

    # Media & documents
    asciinema
    imagemagick
    mediainfo
    peek

    # Nix tools
    cachix
    nix-index
    nix-prefetch-git
    nixos-shell
    nixpkgs-fmt

    # Misc
    bom
    perlPackages.Apprainbarf
    rpm
    signal-desktop
    zoom-us
  ];
}
