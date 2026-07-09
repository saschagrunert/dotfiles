# Tail curl output with auto-refresh
function tailc
    test (count $argv) -ge 1 || begin
        echo "Usage: tailc <url>" >&2
        return 1
    end
    set -l lines (math (tput lines) - 2)
    set -l escaped_url (string replace -a "'" "'\\''" -- $argv[1])
    watch -n1 "curl -sf '$escaped_url' | tail -n $lines"
end
