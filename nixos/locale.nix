{ config, lib, pkgs, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
    };
  };

  console = {
    font = "Lat2-Terminus16";
  };

  time.timeZone = "Europe/Berlin";
}
