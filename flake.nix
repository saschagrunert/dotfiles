{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "sascha";
      dotfilesPath = "/home/${username}/.dotfiles";
      # The LLVM release for the system clang, clangd and the dev shells, so
      # the compiler and the language server never disagree
      llvmVersion = "22";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            nixpkgs
            dotfilesPath
            username
            llvmVersion
            ;
        };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit dotfilesPath username llvmVersion; };
              users.${username} = import ./home.nix;
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;

      devShells.${system} = import ./shells.nix {
        inherit
          pkgs
          nixpkgs
          system
          llvmVersion
          ;
      };
    };
}
