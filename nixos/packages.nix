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
    taplo
    terraform-ls
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
    libcgroup
    lm_sensors
    lshw
    lvm2
    pahole
    perf
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
    chafa
    imagemagick
    kooha
    mediainfo

    # Nix tools
    cachix
    deadnix
    nix-index
    nix-prefetch-git
    nixfmt
    nixos-shell
    statix

    # Misc
    bom
    perlPackages.Apprainbarf
  ];
}
