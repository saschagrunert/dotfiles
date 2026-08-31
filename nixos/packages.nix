{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Desktop & UI
    alacritty
    bemenu
    dunst
    google-chrome
    grim
    j4-dmenu-desktop
    pavucontrol
    piper
    slurp
    wdisplays
    wev
    wl-clipboard
    xdg-utils
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
    jira-cli-go
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
    go_1_27
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
    helm
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
    perf
    lm_sensors
    lshw
    lvm2
    pahole
    strace
    tcpdump
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
