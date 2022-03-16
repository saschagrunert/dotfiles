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
    (vim_configurable.override { python = python39; })
    acpilight
    alacritty
    arandr
    arc-theme
    asciinema
    autojump
    bat
    bats
    binutils
    bpftool
    buildah
    cachix
    calc
    capnproto
    cargo-edit
    cargo-kcov
    #ccache
    cfssl
    clang_13
    cmake
    cni-plugins
    conmon
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
    go_1_18
    gofumpt
    golangci-lint
    google-chrome
    google-cloud-sdk
    gopls
    graphviz
    guvcview
    haskellPackages.alex
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
    python39
    python39Packages.autopep8
    python39Packages.isort
    python39Packages.osc
    python39Packages.yapf
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
    virt-manager
    wget
    xclip
    xorg.xev
    xsel
    yamllint
    yq
    zoom-us
  ];
}
