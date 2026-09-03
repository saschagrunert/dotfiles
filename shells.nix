{ pkgs, ... }:
{
  default = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.llvmPackages_22.clang
      pkgs.pkg-config
    ];
    buildInputs = [
      pkgs.glibc
      pkgs.glibc.static
    ];
    shellHook = ''
      export CFLAGS=$NIX_CFLAGS_COMPILE
    '';
  };
}
