{ config, lib, pkgs, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy ];
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  time.timeZone = "Europe/Berlin";
}
