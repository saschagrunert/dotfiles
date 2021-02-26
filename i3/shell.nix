with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "i3pystatus-run";

  LD_LIBRARY_PATH = "${pkgs.libpulseaudio}/lib";

  buildInputs = with pkgs; [
    libpulseaudio
    (i3pystatus.overrideAttrs (oldAttrs: {
      src = fetchFromGitHub {
        owner = "enkore";
        repo = "i3pystatus";
        rev = "7b861a42f575525e817cecd9bf309c881f2c5c3d";
        sha256 = "1pl6lhdr1jma8if3j5qlnf9s0svk4n8a12bqwkyjwbfkq2nhmasw";
      };
      propagatedBuildInputs = with python38Packages; [
        dbus-python
        pytz
      ] ++ oldAttrs.propagatedBuildInputs;
    }))
  ];

  shellHook = ''
    ./i3py
  '';
}
