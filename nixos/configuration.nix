{ config, lib, pkgs, ... }:

let
  baseconfig = { allowUnfree = true; };
  unstable = import <nixos-unstable> { config = baseconfig; };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>

    <nixos-unstable/nixos/modules/virtualisation/podman.nix>
    <nixos-unstable/nixos/modules/virtualisation/containers.nix>
    <nixos-unstable/nixos/modules/config/users-groups.nix>
  ];
  disabledModules = [
    "virualisation/podman.nix"
    "virualisation/cri-o.nix"
    "config/users-groups.nix"
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/d5d42ad3-d5d6-45ff-8723-44f15d7fcd9c";
          preLVM = true;
        };
      };
    };
    kernelModules = [ "kvm-intel" ];
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.route_localnet" = 1;
        "net.ipv4.conf.all.forwarding" = 1;
        "net.ipv4.conf.default.forwarding" = 1;
      };
    };
    extraModulePackages = [];
    extraModprobeConfig = "options kvm_intel nested=1";
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/779bee49-db2e-4a03-9cdb-fca6156f855f";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/BCC6-032C";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/3da6402f-aae6-4eb1-8b61-71681b654ba0"; } ];
  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  nixpkgs.config = baseconfig // {
    packageOverrides = pkgs: {
      podman = unstable.podman;
      podman-unwrapped = unstable.podman-unwrapped;
      cri-o = unstable.cri-o;
      cri-o-unwrapped = unstable.cri-o-unwrapped;
    };
  };

  environment.variables = {
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
  };
  hardware.opengl.package = (pkgs.mesa.override {
    galliumDrivers = [ "nouveau" "virgl" "swrast" "iris" ];
  }).drivers;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  users.users.sascha = {
    isNormalUser = true;
    home = "/home/sascha";
    description = "Sascha Grunert";
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "libvirtd"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  security = {
    apparmor.enable = true;
    audit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  networking = {
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
  time.timeZone = "Europe/Berlin";

  environment = {
    etc = {
      "apparmor/parser.conf".text = "";
      "cni/net.d/10-crio-bridge.conf".text = ''
        {
          "cniVersion": "0.3.1",
          "name": "crio",
          "type": "bridge",
          "bridge": "cni0",
          "isGateway": true,
          "ipMasq": true,
          "hairpinMode": true,
          "ipam": {
            "type": "host-local",
            "routes": [
              { "dst": "0.0.0.0/0" },
              { "dst": "1100:200::1/24" }
            ],
            "ranges": [
              [{ "subnet": "10.85.0.0/16" }],
              [{ "subnet": "1100:200::/24" }]
            ]
          }
        }
      '';
      "crictl.yaml".text = ''
        runtime-endpoint: unix:///var/run/crio/crio.sock
      '';
    };

    systemPackages = with unstable; [
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
      iptables
      j4-dmenu-desktop
      jq
      kubectl
      kubernetes
      lm_sensors
      lshw
      lxappearance
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
      wget
      xclip
      xorg.xev
      xsel
      yamllint
      yq
      zoom-us
    ];
  };

  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
    light.enable = true;
    mtr.enable = true;
    nm-applet.enable = true;
    vim.defaultEditor = true;
  };

  virtualisation = {
    podman.enable = true;
    cri-o.enable = false;
    libvirtd.enable = false;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      ubuntu_font_family
      nerdfonts
    ];

    fontconfig = {
      penultimate.enable = false;
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "MesloLGSDZ Nerd Font" ];
      };
    };
  };

  sound.enable = true;
  hardware = {
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = true;
  };

  services = {
    locate = {
      enable = true;
      interval = "hourly";
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';
    actkbd = {
      enable = true;
      bindings = [
        { keys = [ 87 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l sascha -c '/run/current-system/sw/bin/light -U 10'"; }
        { keys = [ 88 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l sascha -c '/run/current-system/sw/bin/light -A 10'"; }
      ];
    };
    upower.enable = true;
    xserver = {
      enable = true;
      layout = "de";
      xkbVariant = "nodeadkeys";

      libinput.enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          enable = true;
          greeter.enable = false;
          autoLogin.enable = true;
          autoLogin.user = "sascha";
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
    };
  };

  system.stateVersion = "20.03";
}
