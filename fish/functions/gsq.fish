# Squash commits since merge base
function gsq
    set -l base (gmb)
    test -n "$base" || begin
        echo "Failed to determine merge base" >&2
        return 1
    end
    git reset $base && git add -A && git commit -s
end
