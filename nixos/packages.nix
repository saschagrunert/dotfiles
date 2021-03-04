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
    maxJobs = lib.mkDefault 8;
    trustedUsers = [ "root" "sascha" ];
  };

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      linuxPackages_latest = unstable.linuxPackages_latest;
    };
  };

  environment.systemPackages = with unstable; [
    (vim_configurable.override { python = python3; })
    acpilight
    alacritty
    apparmor-parser
    arandr
    arc-theme
    asciinema
    autojump
    awscli2
    bat
    bats
    binutils
    buildah
    cachix
    calc
    cargo-edit
    cargo-kcov
    ccache
    cfssl
    chromium
    clang
    clang-analyzer
    clang-tools
    cmake
    cni
    cni-plugins
    conmon
    conntrack-tools
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
    go
    go-md2man
    go-protobuf
    gofumpt
    golangci-lint
    google-cloud-sdk
    gopls
    guvcview
    haskellPackages.alex
    hexchat
    htop
    imagemagick
    inetutils
    iptables
    j4-dmenu-desktop
    jq
    kcov
    kubectl
    kubernetes
    kustomize
    ldns
    lm_sensors
    lshw
    lvm2
    lxappearance
    nix-index
    nix-prefetch-git
    nixpkgs-fmt
    nodePackages.prettier
    nodePackages.write-good
    nodejs
    openssl
    openvpn
    parallel
    pavucontrol
    peek
    perlPackages.Apprainbarf
    picom
    nixos-shell
    proselint
    protobuf
    pstree
    python3
    python38Packages.autopep8
    python38Packages.isort
    python38Packages.osc
    python38Packages.yapf
    ranger
    ripgrep
    rpm
    runc
    rustup
    shellcheck
    shfmt
    signal-desktop
    skopeo
    slirp4netns
    spotify
    sysstat
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
