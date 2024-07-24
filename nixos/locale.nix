{ config, lib, pkgs, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
    };
  };

  console = {
    font = "Lat2-Terminus16";
  };

  time.timeZone = "Europe/Berlin";
}
