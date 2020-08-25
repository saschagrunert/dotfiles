{ config, lib, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixpkgs-unstable> { config = baseconfig; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixpkgs-unstable/nixos/modules/services/hardware/tlp.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/cri-o.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/podman.nix>
    <nixpkgs-unstable/nixos/modules/virtualisation/containers.nix>
    <nixpkgs-unstable/nixos/modules/config/users-groups.nix>
  ];

  disabledModules = [
    "services/hardware/tlp.nix"
    "virtualisation/podman.nix"
    "virtualisation/cri-o.nix"
    "config/users-groups.nix"
  ];

  nix.maxJobs = lib.mkDefault 8;

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      tlp = unstable.tlp;
      podman = unstable.podman;
      podman-unwrapped = unstable.podman-unwrapped;
      cri-o = unstable.cri-o;
      cri-o-unwrapped = unstable.cri-o-unwrapped;
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
    chromium
    clang
    clang-tools
    cmake
    cni-plugins
    conmon
    conntrack-tools
    cri-o
    cri-tools
    ctags
    dmenu
    dunst
    etcd
    exa
    fd
    feh
    file
    fzf
    gcc
    ghc
    git
    gnumake
    go
    golangci-lint
    google-cloud-sdk
    haskellPackages.alex
    hexchat
    htop
    imagemagick
    iptables
    j4-dmenu-desktop
    jq
    kubectl
    kubernetes
    kustomize
    ldns
    lm_sensors
    lshw
    lxappearance
    lvm2
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
    python3
    python38Packages.autopep8
    python38Packages.isort
    python38Packages.yapf
    python38Packages.osc
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
