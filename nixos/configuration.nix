{ config, lib, pkgs, nixpkgs, ... }:
{
  imports = [
    "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    ./hosts/desktop
    ./network.nix
    ./security.nix
    ./users.nix
    ./locale.nix
    ./packages.nix
    ./programs.nix
    ./virtualisation.nix
    ./services.nix
    ./fonts.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = lib.mkDefault 8;
    trusted-users = [ "root" "sascha" ];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
