{ config, pkgs, lib, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  dotfiles = "/home/sascha/.dotfiles";
in
{
  home.stateVersion = "24.11";

  home.file = {
    ".hushlogin".text = "";
    ".clang-format".source = link "${dotfiles}/clang/clang-format";
    ".gdbinit".source = link "${dotfiles}/gdb/gdbinit";
    ".gdbinit.d".source = link "${dotfiles}/gdb/gdbinit.d";
    ".ghci".source = link "${dotfiles}/ghci/ghci";
    ".gitconfig".source = link "${dotfiles}/git/gitconfig";
    ".gitignore_global".source = link "${dotfiles}/git/gitignore_global";
    ".gtkrc-2.0".source = link "${dotfiles}/gtk/gtkrc-2.0";
    ".icons".source = link "${dotfiles}/icons";
    ".rustfmt.toml".source = link "${dotfiles}/rustfmt/rustfmt.toml";
    ".tigrc".source = link "${dotfiles}/tig/tigrc";
    ".tmux.conf".source = link "${dotfiles}/tmux/tmux.conf";
    ".vim".source = link "${dotfiles}/vim";
    ".Xdefaults".source = link "${dotfiles}/x11/Xdefaults";
    ".profile".source = link "${dotfiles}/x11/profile";
    ".xinitrc".source = link "${dotfiles}/x11/xinitrc";
    ".ccache/ccache.conf".source = link "${dotfiles}/ccache/ccache.conf";
    ".claude/settings.json".source = link "${dotfiles}/claude/settings.json";
  };

  xdg.configFile = {
    "alacritty".source = link "${dotfiles}/alacritty";
    "bat".source = link "${dotfiles}/bat";
    "dunst".source = link "${dotfiles}/dunst";
    "fish".source = link "${dotfiles}/fish";
    "htop".source = link "${dotfiles}/htop";
    "i3".source = link "${dotfiles}/i3";
    "i3status-rust".source = link "${dotfiles}/i3status-rust";
    "nixpkgs".source = link "${dotfiles}/nixpkgs";
    "picom".source = link "${dotfiles}/picom";
    "ranger".source = link "${dotfiles}/ranger";
  };
}
