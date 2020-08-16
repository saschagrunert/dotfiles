with import <nixpkgs> {};
stdenv.mkDerivation {
    name = "dev-environment";
    buildInputs = [
      btrfs-progs
      glibc
      glibc.static
      gpgme
      libapparmor
      libseccomp
      pkg-config
    ];
}
