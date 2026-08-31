{ pkgs, ... }:
{
  fonts = {
    packages = [
      pkgs.nerd-fonts.meslo-lg
      pkgs.noto-fonts-color-emoji
      pkgs.roboto
      pkgs.roboto-slab
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Roboto Slab" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "MesloLGSDZ Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
