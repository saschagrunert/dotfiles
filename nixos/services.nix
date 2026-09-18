{
  config,
  pkgs,
  username,
  ...
}:
{
  systemd = {
    services.chrome-graceful-shutdown = {
      description = "Gracefully stop Chrome before shutdown";
      wantedBy = [ "multi-user.target" ];
      after = [ "greetd.service" ];
      restartIfChanged = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = username;
        ExecStop = pkgs.writeShellScript "stop-chrome" ''
          main_pid=$(${pkgs.procps}/bin/pgrep --oldest --exact chrome) || true
          if [ -n "$main_pid" ]; then
            kill -SIGTERM "$main_pid"
            ${pkgs.coreutils}/bin/timeout 30 ${pkgs.procps}/bin/pidwait --exact chrome || true
          fi
        '';
        TimeoutStopSec = 45;
      };
    };

    # Dumping a crashed process writes its whole address space to disk before
    # compressing it, which stalls the machine for minutes on large ones. Only
    # ProcessSizeMax skips that write, Storage just drops the result.
    coredump.settings.Coredump = {
      Storage = "none";
      ProcessSizeMax = 0;
    };

    # Order every login session before the Chrome stop hook, so it runs before
    # the session is torn down. The drop-in applies to all session-N.scope
    # units, whatever number greetd's session gets.
    units."session-.scope" = {
      overrideStrategy = "asDropin";
      text = ''
        [Unit]
        Before=chrome-graceful-shutdown.service
      '';
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
      wireplumber.extraConfig."10-disable-bluez-seat-monitoring" = {
        "wireplumber.profiles".main."monitor.bluez.seat-monitoring" = "disabled";
      };
    };

    journald.settings.Journal = {
      RateLimitBurst = 3000;
      SystemMaxUse = "500M";
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
