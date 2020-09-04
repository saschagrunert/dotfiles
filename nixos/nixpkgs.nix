let
  json = builtins.fromJSON (builtins.readFile ./nixpkgs.json);
  nixpkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable";
    url = "${json.url}/archive/${json.rev}.tar.gz";
    inherit (json) sha256;
  });
in
nixpkgs
