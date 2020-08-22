{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./network.nix
    ./security.nix
    ./users.nix
    ./locale.nix
    ./packages.nix
    ./services.nix
    ./fonts.nix
  ];

  system.stateVersion = "20.03";
}
