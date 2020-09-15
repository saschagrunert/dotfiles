{ config, lib, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixpkgs-unstable> { config = baseconfig; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>

    <nixpkgs-unstable/nixos/modules/security/apparmor.nix>
    <nixpkgs-unstable/nixos/modules/services/hardware/tlp.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/containers.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/cri-o.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/podman.nix>
  ];

  disabledModules = [
    "security/apparmor.nix"
    "services/hardware/tlp.nix"
    "virtualisation/cri-o.nix"
    "virtualisation/podman.nix"
  ];

  nix.maxJobs = lib.mkDefault 8;

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      tlp = unstable.tlp;
      podman = unstable.podman;
      podman-unwrapped = unstable.podman-unwrapped;
      cri-o = unstable.cri-o;
      cri-o-unwrapped = unstable.cri-o-unwrapped;
      cri-tools = unstable.cri-tools;
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
    gnumake
    go
    go-md2man
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
    unclutter
    unzip
    usbutils
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
