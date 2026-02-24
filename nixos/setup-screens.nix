{ writeShellScriptBin, dotfilesPath }:
writeShellScriptBin "setup-screens" ''
  set -euo pipefail

  autorandr --change

  # Render the background
  feh --bg-scale ${dotfilesPath}/wallpaper/blurred.jpg
''
