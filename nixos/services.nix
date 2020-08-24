{ config, lib, pkgs, ... }:
{
  virtualisation = {
    podman.enable = true;
    cri-o.enable = true;
    libvirtd.enable = false;
  };

  systemd.services.crio.enable = false;

  programs = {
    bcc.enable = true;
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

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 60;
      };
    };

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
}
