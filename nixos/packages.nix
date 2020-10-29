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

  nix.maxJobs = lib.mkDefault 8;

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      linuxPackages_latest = unstable.linuxPackages_latest;
      nur = import
        (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz")
        {
          inherit pkgs;
        };
    };
  };

  environment.systemPackages = with unstable; [
    (vim_configurable.override { python = python3; })
    acpilight
    alacritty
    apparmor-parser
    arandr
    asciinema
    arc-theme
    autojump
    bat
    bats
    binutils
    buildah
    calc
    cargo-edit
    cargo-kcov
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
    ghc
    ginkgo
    git
    git-lfs
    gitAndTools.gh
    gnumake
    go
    go-md2man
    go-protobuf
    golangci-lint
    google-cloud-sdk
    gopls
    hadolint
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
    linuxPackages_latest.bpftrace
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
    pkgs.nur.repos.mic92.nixos-shell
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
    skopeo
    slirp4netns
    spotify
    sysstat
    teams
    thunderbird
    tig
    tmux
    tokei
    unclutter
    unzip
    usbutils
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
