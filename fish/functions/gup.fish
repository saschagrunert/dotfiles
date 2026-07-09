# Update branch from remote
function gup
    set -l remote $argv[1]
    test -z "$remote" && set remote origin
    git fetch $remote && git merge $remote/(gldb) && git push && gl
end
