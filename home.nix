{
  config,
  pkgs,
  dotfilesPath,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfile = path: link "${dotfilesPath}/${path}";
in
{
  home = {
    stateVersion = "24.11";

    file = {
      ".hushlogin".text = "";
      ".clang-format".source = dotfile "clang/clang-format";
      ".gdbinit".source = dotfile "gdb/gdbinit";
      ".gdbinit.d".source = dotfile "gdb/gdbinit.d";
      ".gitconfig".source = dotfile "git/gitconfig";
      ".gitignore_global".source = dotfile "git/gitignore_global";
      ".rustfmt.toml".source = dotfile "rustfmt/rustfmt.toml";
      ".tigrc".source = dotfile "tig/tigrc";
      ".tmux.conf".source = dotfile "tmux/tmux.conf";
      ".tmux/scripts".source = dotfile "tmux/scripts";
      ".Xdefaults".source = dotfile "x11/Xdefaults";
      ".profile".source = dotfile "x11/profile";
      ".xinitrc".source = dotfile "x11/xinitrc";
      ".claude/settings.json".source = dotfile "claude/settings.json";
    };

    pointerCursor = {
      enable = true;
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
    gtk4.theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Roboto";
      size = 10;
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      desktop = "$HOME";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      music = "$HOME";
      pictures = "$HOME/pictures";
      publicShare = "$HOME";
      templates = "$HOME";
      videos = "$HOME";
      extraConfig = {
        PROJECTS = "$HOME";
      };
    };

    configFile = {
      "alacritty".source = dotfile "alacritty";
      "bat".source = dotfile "bat";
      "dunst".source = dotfile "dunst";
      "fish".source = dotfile "fish";
      "htop".source = dotfile "htop";
      "i3".source = dotfile "i3";
      "i3status-rust".source = dotfile "i3status-rust";
      "nvim".source = dotfile "nvim";
      "ranger".source = dotfile "ranger";
    };
  };
}
