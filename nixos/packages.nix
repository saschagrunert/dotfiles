{ config, lib, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixpkgs-unstable> { config = baseconfig; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/podman.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/containers.nix>
    <nixpkgs-unstable/nixos/modules/config/users-groups.nix>
  ];

  disabledModules = [
    "virualisation/podman.nix"
    "virualisation/cri-o.nix"
    "config/users-groups.nix"
  ];

  nix.maxJobs = lib.mkDefault 8;

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      podman = unstable.podman;
      podman-unwrapped = unstable.podman-unwrapped;
      cri-o = unstable.cri-o;
      cri-o-unwrapped = unstable.cri-o-unwrapped;
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
    binutils
    buildah
    buildah
    calc
    chromium
    clang
    clang-tools
    cmake
    cni-plugins
    conmon
    conntrack-tools
    cri-o
    cri-tools
    dmenu
    dunst
    etcd
    exa
    fd
    feh
    file
    fzf
    gcc
    git
    gnumake
    go
    golangci-lint
    google-cloud-sdk
    hexchat
    htop
    imagemagick
    iptables
    j4-dmenu-desktop
    jq
    kubectl
    kubernetes
    lm_sensors
    lshw
    lxappearance
    nixpkgs-fmt
    nodejs
    openssl
    pavucontrol
    peek
    picom
    python3
    ranger
    ripgrep
    runc
    rustup
    shellcheck
    shfmt
    skopeo
    spotify
    sysstat
    teams
    thunderbird
    tig
    tmux
    unclutter
    unzip
    wget
    xclip
    xorg.xev
    xsel
    yamllint
    yq
    zoom-us
  ];
}
