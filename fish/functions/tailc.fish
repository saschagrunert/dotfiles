# Tail curl output with auto-refresh
function tailc
    set -l lines (math (tput lines) - 2)
    watch -n1 "curl -sf '$argv[1]' | tail -n $lines"
end
