with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "dev-environment";
  buildInputs = [
    autoconf
    automake
    btrfs-progs
    dbus
    glibc
    glibc.static
    gpgme
    libapparmor
    libcap
    (libseccomp.overrideAttrs (x: { dontDisableStatic = true; }))
    libselinux
    libtool
    linuxPackages_latest.bcc
    lvm2
    pkg-config
    systemd
    yajl
  ];
}
