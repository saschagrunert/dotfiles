{ lib, pkgs, ... }:
{
  environment.variables = {
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland,x11";
    _JAVA_AWT_WM_NONREPARENTING = "1";
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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      sway = {
        default = lib.mkForce [
          "wlr"
          "gtk"
        ];
      };
    };
  };

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
      NoNewPrivileges = true;
      RestrictNamespaces = true;
      MemoryDenyWriteExecute = true;
    };
  };
}
