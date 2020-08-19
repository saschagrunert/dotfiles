{ config, lib, pkgs, ... }:
{
  virtualisation = {
    podman.enable = true;
    cri-o.enable = false;
    libvirtd.enable = false;
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
}
