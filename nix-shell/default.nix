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
    (elfutils.overrideAttrs (x: {
      version = "0.188";
      src = fetchurl {
        url = "https://sourceware.org/elfutils/ftp/0.188/elfutils-0.188.tar.bz2";
        sha256 = "sha256-+4sOjQgCAFuaMJxgwdjeMt0pUbVvDDo8tW0hzgFZXf8=";
      };
    }))
    glibc
    glibc.static
    gpgme
    krb5
    libapparmor
    libbpf_1
    libcap
    libselinux
    libtool
    linuxPackages_latest.bcc
    llvmPackages_15.clang-unwrapped
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
