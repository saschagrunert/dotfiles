{ config, lib, pkgs, ... }:
{
  imports = [
    ./hosts/desktop
    ./network.nix
    ./security.nix
    ./users.nix
    ./locale.nix
    ./packages.nix
    ./services.nix
    ./fonts.nix
  ];

  system.stateVersion = "24.11";
}
