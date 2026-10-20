{
  pkgs,
  nixpkgs,
  system,
  llvmVersion,
}:
{
  default = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs."llvmPackages_${llvmVersion}".clang
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
// (
  let
    projectDir = builtins.getEnv "PWD";
  in
  if projectDir != "" then
    {
      project =
        let
          devPkgs = import nixpkgs {
            inherit system;
            overlays = [
              (import "${projectDir}/nix/overlay.nix")
              (_: super: {
                nix-gitignore = super.nix-gitignore // {
                  gitignoreSourcePure = _: _: super.emptyDirectory;
                };
              })
            ];
          };
          drvFile = "${projectDir}/nix/derivation.nix";
          # Project flakes may pass build metadata, which the shell does not need.
          drv = devPkgs.callPackage drvFile (
            builtins.intersectAttrs (builtins.functionArgs (import drvFile)) {
              rev = "";
              lastModified = "0";
            }
          );
        in
        pkgs.mkShell {
          inputsFrom = [ drv ];
          shellHook = ''
            export CFLAGS=$NIX_CFLAGS_COMPILE
          '';
        };
    }
  else
    { }
)
