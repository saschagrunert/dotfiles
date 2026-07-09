# Build nix package
function nb
    set -l PKG (basename "$PWD")
    test (count $argv) -gt 0 && set PKG $argv[1]
    string match -qr '^[a-zA-Z0-9_.+-]+$' -- $PKG || begin
        echo "Invalid package name: $PKG" >&2
        return 1
    end
    nix build --impure --expr "with import (builtins.getFlake \"nixpkgs\") {}; $PKG.overrideAttrs { src = ./.; }"
end
