with import <nixpkgs> { };
writeShellScriptBin "setup-screens" ''
  set -euxo pipefail

  LAPTOP=eDP
  DT=DisplayPort
  MODE=3840x2160

  R=$DT-7

  if xrandr --listmonitors | grep -q $DT-3; then
      L=$DT-3
  else
      L=$DT-2
  fi

  # Initial setup
  xrandr --output $R --mode $MODE --left-of $LAPTOP
  xrandr --output $L --mode $MODE --left-of $R

  # Render the background
  feh --bg-scale ~/.dotfiles/wallpaper/blurred.jpg
''
