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

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    sysstat.enable = true;

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
        Option "BlankTime" "0"
        Option "DPMS" "false"
      '';
    };
  };
}
