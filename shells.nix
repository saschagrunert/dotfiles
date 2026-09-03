{
  pkgs,
  nixpkgs,
  system,
}:
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
          drv = devPkgs.callPackage "${projectDir}/nix/derivation.nix" { };
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
