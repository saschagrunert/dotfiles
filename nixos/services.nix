{ config, lib, pkgs, ... }:
{
  virtualisation = {
    containers = {
      enable = true;
      ociSeccompBpfHook.enable = true;
    };
    cri-o.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
    podman.enable = true;
  };

  systemd.services.crio.enable = false;

  programs = {
    bcc.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    light.enable = true;
    mtr.enable = true;
    nm-applet.enable = true;
    vim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.vim_configurable;
    };
  };

  services = {
    blueman.enable = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "sascha";
      };
      defaultSession = "none+i3";
    };

    pipewire.enable = false;
    printing = {
      enable = true;
      drivers = [ pkgs.hplip pkgs.hplipWithPlugin ];
    };

    journald = {
      rateLimitInterval = "0";
      rateLimitBurst = 0;
    };

    libinput.enable = true;

    locate = {
      enable = true;
      interval = "hourly";
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    '';

    upower.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 60;
      };
    };

    sysstat.enable = true;

    xserver = {
      enable = true;
      dpi = 150;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm = {
          enable = true;
          greeter.enable = false;
        };
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ i3status-rust ];
      };

      xkb.layout = "us";
    };
  };
}
