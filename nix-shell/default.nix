with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "dev-environment";
  buildInputs = [
    autoconf
    automake
    btrfs-progs
    glibc
    glibc.static
    gpgme
    libapparmor
    libseccomp
    libselinux
    libtool
    lvm2
    pkg-config
  ];
}
