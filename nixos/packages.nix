{ config, lib, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixpkgs-unstable> { config = baseconfig; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];
  disabledModules = [ ];

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      max-jobs = lib.mkDefault 8;
      trusted-users = [ "root" "sascha" ];
    };
  };

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      linuxPackages_latest = unstable.linuxPackages_latest;
    };
  };

  environment.systemPackages = with unstable; [
    acpilight
    alacritty
    arandr
    arc-theme
    asciinema
    autojump
    bat
    bats
    binutils
    bpftools
    buildah
    cachix
    calc
    capnproto
    cargo-edit
    cargo-kcov
    cfssl
    clang_14
    clang-tools
    cmake
    cni-plugins
    conmon
    conmon-rs
    conntrack-tools
    cosign
    cri-o
    cri-tools
    crun
    ctags
    dmenu
    dunst
    etcd
    exa
    fd
    feh
    file
    fuse-overlayfs
    fzf
    gcc
    gdb
    ginkgo
    git
    git-lfs
    gitAndTools.gh
    gnumake
    go-md2man
    go-protobuf
    go_1_20
    gofumpt
    golangci-lint
    google-chrome
    google-cloud-sdk
    gopls
    gotools
    graphviz
    guvcview
    haskellPackages.alex
    heaptrack
    hexchat
    htop
    imagemagick
    inetutils
    iptables
    j4-dmenu-desktop
    jq
    jsonnet
    kcov
    kdenlive
    kind
    kubectl
    kubernetes
    kustomize
    ldns
    linuxPackages.bpftrace
    linuxPackages.perf
    lm_sensors
    lshw
    lvm2
    lxappearance
    nix-index
    nix-prefetch-git
    nixos-shell
    nixpkgs-fmt
    nodePackages.prettier
    nodePackages.write-good
    nodejs
    openssl
    openvpn
    pahole
    parallel
    pavucontrol
    peek
    perlPackages.Apprainbarf
    picom
    proselint
    protobuf
    pstree
    python3
    python3Packages.autopep8
    python3Packages.isort
    python3Packages.osc
    python3Packages.yapf
    ranger
    rekor-cli
    ripgrep
    rpm
    runc
    rustup
    shellcheck
    shfmt
    signal-desktop
    skopeo
    slirp4netns
    socat
    spotify
    sysstat
    terraform
    tig
    tmux
    tokei
    unclutter
    unzip
    usbutils
    vagrant
    valgrind
    vim_configurable
    virt-manager
    wget
    xclip
    xorg.xev
    xsel
    yamllint
    yq-go
    zoom-us
  ];
}
