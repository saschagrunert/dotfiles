{ config, pkgs, dotfilesPath, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home = {
    stateVersion = "24.11";

    file = {
      ".hushlogin".text = "";
      ".clang-format".source = link "${dotfilesPath}/clang/clang-format";
      ".gdbinit".source = link "${dotfilesPath}/gdb/gdbinit";
      ".gdbinit.d".source = link "${dotfilesPath}/gdb/gdbinit.d";
      ".ghci".source = link "${dotfilesPath}/ghci/ghci";
      ".gitconfig".source = link "${dotfilesPath}/git/gitconfig";
      ".gitignore_global".source = link "${dotfilesPath}/git/gitignore_global";
      ".rustfmt.toml".source = link "${dotfilesPath}/rustfmt/rustfmt.toml";
      ".tigrc".source = link "${dotfilesPath}/tig/tigrc";
      ".tmux.conf".source = link "${dotfilesPath}/tmux/tmux.conf";
      ".tmux/scripts".source = link "${dotfilesPath}/tmux/scripts";
      ".Xdefaults".source = link "${dotfilesPath}/x11/Xdefaults";
      ".profile".source = link "${dotfilesPath}/x11/profile";
      ".xinitrc".source = link "${dotfilesPath}/x11/xinitrc";
      ".ccache/ccache.conf".source = link "${dotfilesPath}/ccache/ccache.conf";
      ".claude/settings.json".source = link "${dotfilesPath}/claude/settings.json";
      "games/shadow/shell.nix".source = link "${dotfilesPath}/shadow/shell.nix";
      "games/shadow/alive.sh".source = link "${dotfilesPath}/shadow/alive.sh";
    };

    pointerCursor = {
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
      size = 32;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  systemd.user.services = {
    blueman-applet = {
      Unit = {
        Description = "Blueman Bluetooth applet";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.blueman}/bin/blueman-applet";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    picom = {
      Unit = {
        Description = "Picom compositor";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.picom}/bin/picom";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    ibus-daemon = {
      Unit = {
        Description = "IBus input method daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.ibus-with-plugins}/bin/ibus-daemon --xim --replace";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Sans";
      size = 10;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/desktop";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      publicShare = "$HOME/public";
      templates = "$HOME/templates";
      videos = "$HOME/videos";
    };

    dataFile = {
      "applications/shadow-pc.desktop".source = link "${dotfilesPath}/shadow/shadow-pc.desktop";
    };

    configFile = {
      "alacritty".source = link "${dotfilesPath}/alacritty";
      "bat".source = link "${dotfilesPath}/bat";
      "dunst".source = link "${dotfilesPath}/dunst";
      "fish".source = link "${dotfilesPath}/fish";
      "htop".source = link "${dotfilesPath}/htop";
      "i3".source = link "${dotfilesPath}/i3";
      "i3status-rust".source = link "${dotfilesPath}/i3status-rust";
      "picom".source = link "${dotfilesPath}/picom";
      "nvim".source = link "${dotfilesPath}/nvim";
      "ranger".source = link "${dotfilesPath}/ranger";
    };
  };
}
