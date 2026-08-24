{ pkgs }:
pkgs.mkShell {
  buildInputs = [
    (pkgs.libseccomp.overrideAttrs (_x: {
      doCheck = false;
      dontDisableStatic = true;
    }))
    (pkgs.zstd.override { static = true; })
    pkgs.autoconf
    pkgs.automake
    pkgs.btrfs-progs
    pkgs.dbus
    pkgs.elfutils
    pkgs.glibc
    pkgs.glibc.static
    pkgs.gpgme
    pkgs.jansson
    pkgs.krb5
    pkgs.libapparmor
    pkgs.libbpf
    pkgs.libcap
    pkgs.libselinux
    pkgs.libtool
    pkgs.linuxPackages_latest.bcc
    pkgs.llvmPackages_22.clang-unwrapped
    pkgs.lvm2
    pkgs.pkg-config
    pkgs.systemd
    pkgs.yajl
    pkgs.zlib
    pkgs.zlib.static
  ];
  shellHook = ''
    export CFLAGS=$NIX_CFLAGS_COMPILE
  '';
}
