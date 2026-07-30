# Remove remote branch and prune local
function grm
    test (count $argv) -ge 1 || begin
        echo "Usage: grm <branch> [branch...]" >&2
        return 1
    end
    echo "Delete remote branches: $argv? [y/N]"
    read -l confirm
    test "$confirm" = y || test "$confirm" = Y || return 1
    for branch in $argv
        git push origin :$branch
    end
    gpl
end
