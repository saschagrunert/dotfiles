{ config, lib, pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.meslo-lg
      roboto
      roboto-slab
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Roboto Slab" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "MesloLGSDZ Nerd Font" ];
      };
    };
  };
}
