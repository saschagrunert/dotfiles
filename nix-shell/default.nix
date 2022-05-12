with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "dev-environment";
  buildInputs = [
    (libseccomp.overrideAttrs (x: {
      doCheck = false;
      dontDisableStatic = true;
    }))
    autoconf
    automake
    btrfs-progs
    dbus
    glibc
    glibc.static
    gpgme
    krb5
    libapparmor
    libbpf
    libcap
    libelf
    libselinux
    libtool
    linuxPackages_latest.bcc
    llvmPackages_13.clang-unwrapped
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
