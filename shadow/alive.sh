#!/usr/bin/env nix-shell
#!nix-shell -i bash -p xdotool
set -euo pipefail

INTERVAL="${1:-120}"
SHADOW_WID=$(xdotool search --name "Shadow PC - Display" | head -1 || true)

if [[ -z "$SHADOW_WID" ]]; then
    echo "Could not find Shadow window. Available windows:"
    xdotool search --name "" getwindowname %@ 2>/dev/null | head -20
    exit 1
fi

echo "Found Shadow window: $(xdotool getwindowname "$SHADOW_WID") (id: $SHADOW_WID)"
echo "Sending input every ${INTERVAL}s. Ctrl+C to stop."

while true; do
    sleep "$INTERVAL"
    xdotool key --window "$SHADOW_WID" shift
    printf '.'
done
