{
  config,
  lib,
  pkgs,
  dotfilesPath,
  hostName,
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

    # ~/.config/fish and ~/.config/sway used to be symlinks to the whole
    # directory in the repository. Now that they are linked file by file, the
    # stale directory link has to go before anything else: home-manager would
    # otherwise create the new links through it, straight back into the
    # repository, and back the originals up as .hm-backup. Safe to delete once
    # it has run on every machine, like the migration below.
    activation.dropStaleConfigDirLinks = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      for dir in fish sway; do
        stale="${config.xdg.configHome}/$dir"
        if [ -L "$stale" ]; then
          run rm "$stale"
        fi
      done
    '';

    # One-time migration: fish_variables used to be written into the repository,
    # because the whole fish directory was symlinked. Move it next to the new
    # per-file links so the universal variables survive. Safe to delete once it
    # has run on every machine.
    activation.migrateFishVariables = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      old="${dotfilesPath}/fish/fish_variables"
      new="${config.xdg.configHome}/fish/fish_variables"
      if [ -f "$old" ] && [ ! -e "$new" ]; then
        run mkdir -p "$(dirname "$new")"
        run mv "$old" "$new"
      fi
    '';

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

      # Same, so the machine-specific include can live inside the directory
      "sway/config".source = dotfile "sway/config";
      "sway/workspace-scroll".source = dotfile "sway/workspace-scroll";
      "sway/config.local".source = dotfile "sway/hosts/${hostName}.conf";
    };
  };
}
