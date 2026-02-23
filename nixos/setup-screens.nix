{ writeShellScriptBin }:
writeShellScriptBin "setup-screens" ''
  set -euo pipefail

  autorandr --change

  # Render the background
  feh --bg-scale ~/.dotfiles/wallpaper/blurred.jpg
''
