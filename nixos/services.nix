{ pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      publish.enable = true;
      publish.addresses = true;
    };

    blueman.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "sascha";
        };
      };
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

    ratbagd.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swayidle
      swaybg
      waybar
    ];
  };
}
