{ config, lib, pkgs, ... }:
{
  programs = {
    bcc.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    light.enable = true;
    mtr.enable = true;
    nix-ld.enable = true;
    nm-applet.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
