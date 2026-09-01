{ pkgs, ... }:
{
  services = {
    blueman.enable = true;

    fail2ban.enable = true;

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
      wireplumber.extraConfig."10-disable-battery" = {
        "wireplumber.profiles".main."monitor.bluez.seat-monitoring" = "disabled";
      };
    };

    journald = {
      rateLimitInterval = "30s";
      rateLimitBurst = 3000;
      extraConfig = "SystemMaxUse=500M";
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
    sysstat.enable = true;

    ratbagd.enable = true;
  };
}
