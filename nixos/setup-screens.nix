with import <nixpkgs> { };
writeShellScriptBin "setup-screens" ''
  set -euxo pipefail

  LAPTOP=eDP-1
  L=DP-4
  R=DP-8
  MODE=3840x2160

  # Initial setup
  xrandr --output $R --mode $MODE --left-of $LAPTOP
  xrandr --output $L --mode $MODE --left-of $R

  # Render the background
  feh --bg-scale ~/.dotfiles/wallpaper/blurred.jpg

  xset dpms force off
''
