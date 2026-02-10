with import <nixpkgs> { };
writeShellScriptBin "setup-screens" ''
  set -euxo pipefail

  DT=DisplayPort
  LAPTOP=eDP

  L=$DT-2
  R=$DT-7

  MODE=3840x2160

  # Initial setup
  xrandr --output $R --mode $MODE --left-of $LAPTOP
  xrandr --output $L --mode $MODE --left-of $R

  # Render the background
  feh --bg-scale ~/.dotfiles/wallpaper/blurred.jpg
''
