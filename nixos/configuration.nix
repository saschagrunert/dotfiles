{
  nixpkgs,
  modulesPath,
  username,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hosts/desktop
    ./desktop.nix
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

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-outputs = true;
      keep-derivations = false;
      trusted-users = [ username ];

      # Every command in the dotfiles repository runs against a dirty tree.
      warn-dirty = false;

      # /tmp is a tmpfs sized at half of RAM, so a large uncached build would
      # run in memory. Build on disk instead.
      build-dir = "/var/tmp";
    };

    # Set explicitly: the automatic nixpkgs.flake defaults only record the store
    # path, which drops the rev (nixpkgs#lib.version turns into 19700101.dirty)
    # and sends <nixpkgs> lookups through the global flake registry.
    nixPath = [ "nixpkgs=${nixpkgs}" ];
    registry.nixpkgs.flake = nixpkgs;

    optimise.automatic = true;

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05"; # First installed on 25.05, do not change
}
