{ pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      publish.enable = true;
      publish.addresses = true;
    };

    autorandr.enable = true;
    blueman.enable = true;

    displayManager = {
      autoLogin = {
        enable = true;
        user = "sascha";
      };
      defaultSession = "none+i3";
    };

    fstrim.enable = true;
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
      rateLimitBurst = 3000;
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
      };
    };

    earlyoom.enable = true;
    thermald.enable = true;
    sysstat.enable = true;

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };

    xserver = {
      enable = true;
      dpi = 150;

      displayManager = {
        lightdm = {
          enable = true;
          greeter.enable = false;
        };
      };

      videoDrivers = [ "amdgpu" ];

      windowManager.i3 = {
        enable = true;
        extraPackages = [ pkgs.i3status-rust ];
      };

      xkb.layout = "us";

      serverFlagsSection = ''
        Option "OffTime" "10"
        Option "DPMS" "true"
      '';
    };
  };
}
