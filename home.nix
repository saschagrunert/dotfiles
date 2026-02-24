{ config, pkgs, lib, dotfilesPath, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "24.11";

  home.file = {
    ".hushlogin".text = "";
    ".clang-format".source = link "${dotfilesPath}/clang/clang-format";
    ".gdbinit".source = link "${dotfilesPath}/gdb/gdbinit";
    ".gdbinit.d".source = link "${dotfilesPath}/gdb/gdbinit.d";
    ".ghci".source = link "${dotfilesPath}/ghci/ghci";
    ".gitconfig".source = link "${dotfilesPath}/git/gitconfig";
    ".gitignore_global".source = link "${dotfilesPath}/git/gitignore_global";
    ".gtkrc-2.0".source = link "${dotfilesPath}/gtk/gtkrc-2.0";
    ".icons".source = link "${dotfilesPath}/icons";
    ".rustfmt.toml".source = link "${dotfilesPath}/rustfmt/rustfmt.toml";
    ".tigrc".source = link "${dotfilesPath}/tig/tigrc";
    ".tmux.conf".source = link "${dotfilesPath}/tmux/tmux.conf";
    ".tmux/scripts".source = link "${dotfilesPath}/tmux/scripts";
    ".Xdefaults".source = link "${dotfilesPath}/x11/Xdefaults";
    ".profile".source = link "${dotfilesPath}/x11/profile";
    ".xinitrc".source = link "${dotfilesPath}/x11/xinitrc";
    ".ccache/ccache.conf".source = link "${dotfilesPath}/ccache/ccache.conf";
    ".claude/settings.json".source = link "${dotfilesPath}/claude/settings.json";
  };

  xdg.configFile = {
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
}
