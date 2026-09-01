{ pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  services.resolved.enable = true;
}
