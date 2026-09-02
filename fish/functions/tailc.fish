# Tail curl output with auto-refresh
function tailc
    test (count $argv) -ge 1 || begin
        echo "Usage: tailc <url>" >&2
        return 1
    end
    set -l lines (math (tput lines) - 2)
    watch -n1 -- curl -sf -- $argv[1] \| tail -n $lines
end
