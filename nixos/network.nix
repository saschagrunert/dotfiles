{ pkgs, hostName, ... }:
{
  networking = {
    inherit hostName;
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
      wifi.powersave = false;
    };
  };

  services.resolved.enable = true;
}
