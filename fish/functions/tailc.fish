# Tail curl output with auto-refresh
function tailc
    watch -n1 "curl -sf '$argv[1]' | tail -n \$(($(tput lines) - 2))"
end
