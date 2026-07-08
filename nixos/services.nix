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
      rateLimitInterval = "30s";
      rateLimitBurst = 10000;
    };

    libinput.enable = true;

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amd_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
      ACTION=="bind", SUBSYSTEM=="usb", DRIVER=="snd-usb-audio", ATTRS{idVendor}=="10f5", ATTRS{idProduct}=="7001", RUN+="${pkgs.bash}/bin/bash -c 'echo %k > /sys/bus/usb/drivers/snd-usb-audio/unbind 2>/dev/null'"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="10f5", ENV{DEVTYPE}=="usb_device", TAG+="usbip-autoexport", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.linuxPackages.usbip}/bin/usbip bind -b %k 2>/dev/null || true'"
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

    tailscale.enable = true;

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

      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "DPMS" "false"
      '';
    };
  };

  systemd.services.tailscaled.wantedBy = lib.mkForce [];
}
