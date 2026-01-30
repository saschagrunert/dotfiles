with import <nixpkgs> { };
writeShellScriptBin "setup-screens" ''
  set -euxo pipefail

  DT=DP
  LAPTOP=eDP-1
  L=$DT-3
  R=$DT-8
  MODE=3840x2160


  # Initial setup
  xrandr --output $R --mode $MODE --left-of $LAPTOP
  xrandr --output $L --mode $MODE --left-of $R

  # Render the background
  feh --bg-scale ~/.dotfiles/wallpaper/blurred.jpg
''
