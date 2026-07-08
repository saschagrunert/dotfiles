{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      dotfilesPath = "/home/sascha/.dotfiles";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixpkgs dotfilesPath; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit dotfilesPath; };
              users.sascha = import ./home.nix;
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixpkgs-fmt;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (libseccomp.overrideAttrs (_x: {
            doCheck = false;
            dontDisableStatic = true;
          }))
          (zstd.override { static = true; })
          autoconf
          automake
          btrfs-progs
          dbus
          elfutils
          glibc
          glibc.static
          gpgme
          jansson
          krb5
          libapparmor
          libbpf
          libcap
          libselinux
          libtool
          linuxPackages_latest.bcc
          llvmPackages_21.clang-unwrapped
          lvm2
          pkg-config
          systemd
          yajl
          zlib
          zlib.static
        ];
        shellHook = ''
          export CFLAGS=$NIX_CFLAGS_COMPILE
        '';
      };
    };
}
