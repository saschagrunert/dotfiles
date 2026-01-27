{ config, lib, pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
    useDHCP = false;
    interfaces = {
      wlp1s0.useDHCP = true;
    };
    firewall = {
      allowedTCPPorts = [ 8000 ];
    };
  };
}
