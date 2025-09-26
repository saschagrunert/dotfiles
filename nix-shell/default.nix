with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "dev-environment";
  buildInputs = [
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
    libbpf_1
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
}
