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
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
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
    binutils
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
    go_1_15
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
    kustomize
    lm_sensors
    lshw
    lxappearance
    nixpkgs-fmt
    nodePackages.prettier
    nodejs
    openssl
    pavucontrol
    peek
    picom
    pkgs.nur.repos.mic92.nixos-shell
    python3
    ranger
    ripgrep
    rpm
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
