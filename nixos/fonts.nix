{ config, lib, pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts
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
