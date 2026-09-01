# Update branch from remote, sync origin, prune merged branches
function gup
    set -l remote $argv[1]
    test -z "$remote" && set remote origin
    set -l default_branch (gldb)

    git fetch --prune --no-tags $remote "+refs/heads/*:refs/remotes/$remote/*" \
        && git merge $remote/$default_branch \
        && git push \
        || return $status

    if test "$remote" != origin
        git fetch --prune --no-tags origin "+refs/heads/*:refs/remotes/origin/*" || return $status
    end

    for branch in (git branch --merged $default_branch | grep -v '^\*' | string trim | grep -v "^$default_branch\$")
        git branch -d $branch
    end

    echo
    git branch
end
