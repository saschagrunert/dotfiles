function gsq
    set -l current (git rev-parse --abbrev-ref HEAD)
    set -l default (gldb)
    if test "$current" = "$default"
        echo "Refusing to squash on default branch ($default)" >&2
        return 1
    end
    if not git diff --quiet; or not git diff --cached --quiet
        echo "Working tree is dirty; commit or stash changes first" >&2
        return 1
    end
    set -l base (gmb)
    test -n "$base" || begin
        echo "Failed to determine merge base" >&2
        return 1
    end
    git reset --soft $base && git commit -s
end
