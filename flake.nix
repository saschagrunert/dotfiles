{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      dotfilesPath = "/home/sascha/.dotfiles";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixpkgs nixos-hardware dotfilesPath; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit dotfilesPath; };
            home-manager.users.sascha = import ./home.nix;
          }
        ];
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (libseccomp.overrideAttrs (x: {
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
