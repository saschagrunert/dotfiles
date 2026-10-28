{ pkgs, ... }:
{
  environment.variables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL = "1";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="powercap", KERNEL=="intel-rapl:0|amd_rapl:0", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod a+r /sys/class/powercap/%k/energy_uj"
  '';

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      waybar
    ];
  };

  programs.dconf.enable = true;

  systemd.user.services.polkit-gnome-agent = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
      NoNewPrivileges = true;
      RestrictNamespaces = true;
      MemoryDenyWriteExecute = true;
      # Home and the runtime directory stay hidden, so the agent cannot reach
      # the keys in home or the gpg, ssh and sway sockets next to the ones it
      # needs. Only the session bus, the Wayland socket and the GTK, dconf,
      # font and cursor settings are mounted back, otherwise the dialog falls
      # back to Xwayland without the theme. sway takes wayland-1 as the only
      # compositor of the session. Every path is optional, so a missing one
      # degrades the dialog instead of failing the unit, which would leave
      # pkexec without an agent.
      ProtectHome = "tmpfs";
      ProtectSystem = "strict";
      BindReadOnlyPaths = [
        "-%t/bus"
        "-%t/wayland-1"
        "-%h/.config/dconf"
        "-%h/.config/fontconfig"
        "-%h/.config/gtk-3.0"
        "-%h/.icons"
        "-%h/.local/share/icons"
      ];
      # dconf writes its runtime file here. dconf-service is started on
      # demand, so the directory is created first, outside the sandbox (+),
      # where the read-only runtime directory cannot get in the way.
      ExecStartPre = "+${pkgs.coreutils}/bin/mkdir -p %t/dconf";
      BindPaths = [ "%t/dconf" ];
    };
  };
}
