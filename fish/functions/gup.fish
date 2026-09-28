# Fast-forward the default branch from remote, sync origin, prune merged
# branches. --ff-only refuses to merge into a feature branch or a diverged one.
function gup
    set -l remote $argv[1]
    if test -z "$remote"
        git remote | string match -q base && set remote base || set remote origin
    end
    set -l default_branch (gldb)

    git fetch --prune --no-tags $remote "+refs/heads/*:refs/remotes/$remote/*" \
        && git merge --ff-only $remote/$default_branch \
        && git push \
        || return $status

    if test "$remote" != origin
        git fetch --prune --no-tags origin "+refs/heads/*:refs/remotes/origin/*" || return $status
    end

    set -l current (git branch --show-current)
    for branch in (git branch --merged $default_branch | grep -v '^[*+]' | string trim | grep -v "^$default_branch\$")
        test "$branch" = "$current" && continue
        git branch -d $branch
    end

    echo
    git branch
end
