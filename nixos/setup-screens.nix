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

  # Fix the flickering
  xrandr --output $L --off
  xrandr --output $R --off

  # Re-setup
  xrandr --output $R --mode $MODE --left-of $LAPTOP
  xrandr --output $L --mode $MODE --left-of $R

  # Set the DPI
  xrandr --dpi 150

  # Render the background
  feh --bg-scale ~/.dotfiles/wallpaper/blurred.jpg
''

