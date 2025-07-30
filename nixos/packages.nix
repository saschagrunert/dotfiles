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
    (import ./setup-screens.nix)
    acpilight
    alacritty
    arandr
    arc-theme
    asciinema
    autojump
    bat
    bats
    binutils
    bom
    bpftools
    buf
    buildah
    cachix
    calc
    capnproto
    cargo-edit
    cargo-watch
    cfssl
    clang-tools
    clang_18
    claude-code
    cmake
    cni-plugins
    conmon
    conmon-rs
    conntrack-tools
    cosign
    cri-o
    cri-tools
    criu
    crun
    ctags
    dmenu
    dunst
    eza
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
    go_1_24
    gofumpt
    golangci-lint
    google-chrome
    google-cloud-sdk
    gopls
    gotools
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
    kind
    kubectl
    kubernetes
    kustomize
    ldns
    lima
    lm_sensors
    lshw
    lvm2
    lxappearance
    mediainfo
    nix-index
    nix-prefetch-git
    nixos-shell
    nixpkgs-fmt
    nodePackages.prettier
    openssl
    openvpn
    oras
    pahole
    parallel
    pavucontrol
    peek
    perlPackages.Apprainbarf
    picom
    proselint
    protobuf
    protolint
    pstree
    python3
    python3Packages.autopep8
    python3Packages.isort
    python3Packages.osc
    python3Packages.yapf
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
    socat
    sysstat
    tig
    tmux
    typos
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
    yq-go
    zoom-us
  ];
}
