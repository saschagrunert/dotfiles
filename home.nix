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
    stateVersion = "25.05";

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
      ".claude/settings.json".source = dotfile "claude/settings.json";
    };

    pointerCursor = {
      enable = true;
      name = "Bibata-Original-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
    };
  };

  systemd.user.services = {

    mako = {
      Unit = {
        Description = "Mako notification daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    swayidle = {
      Unit = {
        Description = "Sway idle management daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = toString (
          pkgs.writeShellScript "swayidle-start" ''
            ${pkgs.swayidle}/bin/swayidle -w \
              timeout 600 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"'
          ''
        );
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
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
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/mailto" = "google-chrome.desktop";
        "image/png" = "google-chrome.desktop";
        "image/jpeg" = "google-chrome.desktop";
        "application/pdf" = "google-chrome.desktop";
      };
    };
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
      "mako".source = dotfile "mako";
      "fuzzel".source = dotfile "fuzzel";
      "fish".source = dotfile "fish";
      "htop".source = dotfile "htop";
      "sway".source = dotfile "sway";
      "waybar".source = dotfile "waybar";
      "nvim".source = dotfile "nvim";
      "ranger".source = dotfile "ranger";
    };
  };
}
