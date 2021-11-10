with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "dev-environment";
  buildInputs = [
    (libseccomp.overrideAttrs (x: { dontDisableStatic = true; }))
    autoconf
    automake
    btrfs-progs
    dbus
    glibc
    glibc.static
    gpgme
    libapparmor
    libbpf
    libcap
    libelf
    libselinux
    libtool
    linuxPackages_latest.bcc
    llvmPackages_12.clang-unwrapped
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
}
