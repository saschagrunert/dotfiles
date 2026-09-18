{
  config,
  pkgs,
  dotfilesPath,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfile = path: link "${dotfilesPath}/${path}";
  idleTimeout = 600;
  # Shared by the session daemons below. They are simple user services that
  # never need new privileges, namespaces or writable-executable memory.
  hardening = {
    NoNewPrivileges = true;
    RestrictNamespaces = true;
    MemoryDenyWriteExecute = true;
  };
in
{
  imports = [ ./home/packages.nix ];

  home = {
    stateVersion = "25.05";

    file = {
      ".hushlogin".text = "";
      ".clang-format".source = dotfile "clang/clang-format";
      ".gitconfig".source = dotfile "git/gitconfig";
      ".gitignore_global".source = dotfile "git/gitignore_global";
      ".rustfmt.toml".source = dotfile "rustfmt/rustfmt.toml";
      ".tmux.conf".source = dotfile "tmux/tmux.conf";
      ".tmux/scripts".source = dotfile "tmux/scripts";
      ".claude/settings.json".source = dotfile "claude/settings.json";
      ".claude/CLAUDE.md".source = dotfile "claude/CLAUDE.md";
      ".claude-max/settings.json".source = dotfile "claude/settings.json";
      ".claude-max/CLAUDE.md".source = dotfile "claude/CLAUDE.md";
      ".claude-max/projects".source = link "${config.home.homeDirectory}/.claude/projects";
      ".claude-max/skills".source = link "${config.home.homeDirectory}/.claude/skills";
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

    # mako is D-Bus activated, so services.mako only installs the package and
    # the activation file. The unit is written here to start it with the
    # session, restart it on failure and apply the hardening above.
    mako = {
      Unit = {
        Description = "Mako notification daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = hardening // {
        ExecStart = "${pkgs.mako}/bin/mako";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # The module below writes the unit, this only adds the hardening
    swayidle.Service = hardening // {
      RestartSec = 2;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = idleTimeout;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    gtk4.theme = null;
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
      "sway".source = dotfile "sway";
      "waybar".source = dotfile "waybar";
      "nvim".source = dotfile "nvim";
      "btop".source = dotfile "btop";
      "lazygit".source = dotfile "lazygit";
      "yazi".source = dotfile "yazi";

      # Linked file by file rather than as a directory, because fish writes
      # fish_variables next to its config and that would land in the repository.
      "fish/config.fish".source = dotfile "fish/config.fish";
      "fish/aliases.fish".source = dotfile "fish/aliases.fish";
      "fish/functions".source = dotfile "fish/functions";
      "fish/themes".source = dotfile "fish/themes";
    };
  };
}
