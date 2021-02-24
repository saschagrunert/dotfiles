{ config, lib, pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp82s0.useDHCP = true;
    };
  };
}
