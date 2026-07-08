{ pkgs, ... }:
{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        typing-booster
      ];
    };
  };

  console = {
    font = "Lat2-Terminus16";
  };

  time.timeZone = "Europe/Berlin";
}
