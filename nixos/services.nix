{ pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swayidle
      waybar
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.dconf.enable = true;

  systemd.user.services.polkit-gnome-agent = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
