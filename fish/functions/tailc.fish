# Tail curl output with auto-refresh
function tailc
    test (count $argv) -ge 1 || begin
        echo "Usage: tailc <url>" >&2
        return 1
    end
    set -l lines (math (tput lines) - 2)
    set -gx __TAILC_URL $argv[1]
    watch -n1 -- 'curl -sf -- "$__TAILC_URL" | tail -n '$lines
    set -e __TAILC_URL
end
