{ nixpkgs, ... }:
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
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    trusted-users = [ "root" "sascha" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
