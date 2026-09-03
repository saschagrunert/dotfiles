{
  config,
  pkgs,
  username,
  ...
}:
{
  systemd.services.chrome-graceful-shutdown = {
    description = "Gracefully stop Chrome before shutdown";
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = pkgs.writeShellScript "stop-chrome" ''
        ${pkgs.procps}/bin/pkill -SIGTERM --exact chrome || true
        ${pkgs.procps}/bin/pidwait --exact chrome || true
      '';
      TimeoutStopSec = 45;
    };
  };

  services = {
    blueman.enable = true;

    fail2ban = {
      enable = true;
      jails.sshd.settings = {
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
