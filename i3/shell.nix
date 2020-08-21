with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "i3pystatus-run";

  LD_LIBRARY_PATH = "${pkgs.libpulseaudio}/lib";

  buildInputs = with pkgs; [
    libpulseaudio
    (i3pystatus.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = with python37Packages; [
        dbus-python
        pytz
      ] ++ oldAttrs.propagatedBuildInputs;
    }))
  ];

  shellHook = ''
    ./i3py
  '';
}
