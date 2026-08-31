{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool
    pkgs.llvmPackages_22.clang-unwrapped
    pkgs.pkg-config
  ];
  buildInputs = [
    (pkgs.libseccomp.overrideAttrs (_x: {
      doCheck = false;
      dontDisableStatic = true;
    }))
    (pkgs.zstd.override { static = true; })
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
    pkgs.linuxPackages_latest.bcc
    pkgs.lvm2
    pkgs.systemd
    pkgs.yajl
    pkgs.zlib
    pkgs.zlib.static
  ];
  shellHook = ''
    export CFLAGS=$NIX_CFLAGS_COMPILE
  '';
}
