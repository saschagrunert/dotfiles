# Build nix package
function nb
    set -l PKG (basename "$PWD")
    test (count $argv) -gt 0 && set PKG "$argv"
    nix build --impure --expr "with import (builtins.getFlake \"nixpkgs\") {}; $PKG.overrideAttrs { src = ./.; }"
end
