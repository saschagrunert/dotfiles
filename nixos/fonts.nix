{ pkgs, ... }:
{
  fonts = {
    packages = [
      pkgs.nerd-fonts.meslo-lg
      pkgs.roboto
      pkgs.roboto-slab
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
