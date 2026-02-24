{ config, lib, pkgs, ... }:
{
  services = {
    autorandr.enable = true;
    blueman.enable = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "sascha";
      };
      defaultSession = "none+i3";
    };

    fwupd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.hplip
      ];
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

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amd_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
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

      videoDrivers = [ "amdgpu" ];

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ i3status-rust ];
      };

      xkb.layout = "us";
    };
  };
}
