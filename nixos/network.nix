{ config, lib, pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      wlp1s0.useDHCP = true;
    };
  };
}
