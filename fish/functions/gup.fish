# Update branch from remote, sync origin, prune merged branches
function gup
    set -l remote $argv[1]
    test -z "$remote" && set remote origin
    set -l default_branch (gldb)

    git fetch --prune $remote \
        && git merge $remote/$default_branch \
        && git push \
        || return $status

    test "$remote" != origin && git fetch --prune origin || return $status

    for branch in (git branch --merged $default_branch | grep -v '^\*' | string trim | grep -v "^$default_branch\$")
        git branch -d $branch
    end

    echo
    git branch
end
