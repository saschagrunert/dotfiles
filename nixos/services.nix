{
  config,
  username,
  ...
}:
{
  services = {
    blueman.enable = true;

    fail2ban = {
      enable = true;
      jails.sshd.settings = {
        enabled = true;
        maxretry = 3;
        findtime = 600;
        bantime = 3600;
      };
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${config.programs.sway.package}/bin/sway";
          user = username;
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

    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
      enableNotifications = true;
    };
    sysstat.enable = true;

    ratbagd.enable = true;
  };
}
