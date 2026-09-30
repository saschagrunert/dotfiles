# Fetch the remote, fast-forward the default branch when it is checked out,
# sync origin, prune merged branches and their worktrees. --ff-only refuses
# to merge a diverged default branch.
function gup
    set -l remote $argv[1]
    if test -z "$remote"
        git remote | string match -q base && set remote base || set remote origin
    end
    set -l default_branch (gldb)
    set -l upstream $remote/$default_branch
    set -l current (git branch --show-current)

    git fetch --prune --no-tags $remote "+refs/heads/*:refs/remotes/$remote/*" || return $status
    if not git rev-parse -q --verify refs/remotes/$upstream >/dev/null
        echo "No $upstream branch" >&2
        return 1
    end

    # Merging into and pushing another branch, for example from a linked
    # worktree, would fast-forward it to the default branch and recreate it on
    # origin.
    if test "$current" = $default_branch
        git merge --ff-only $upstream && git push || return $status
    end

    if test "$remote" != origin
        git fetch --prune --no-tags origin "+refs/heads/*:refs/remotes/origin/*" || return $status
    end

    # A branch is merged when its tip reached the default branch through a
    # merge commit, or when git cherry finds an equivalent patch for each of
    # its commits (rebase merges, squash merges of a single commit). A tip on
    # the first-parent line is a new branch without commits, keep it. Compare
    # against the remote branch, the local one is stale when not checked out.
    set -l mainline (git rev-list --first-parent $upstream)
    set -l ancestors (git for-each-ref --merged $upstream --format='%(refname:lstrip=2)' refs/heads)

    # Drop stale entries first, their branches count as not checked out then
    git worktree prune
    set -l main (git worktree list --porcelain | string replace -rf '^worktree ' '')[1]

    for ref in (git for-each-ref --format='%(refname:lstrip=2) %(objectname) %(worktreepath)' refs/heads)
        set -l fields (string split -m2 ' ' -- $ref)
        set -l branch $fields[1]
        set -l worktree $fields[3]
        contains -- $branch $default_branch $current && continue
        test "$worktree" = "$main" && continue

        if contains -- $branch $ancestors
            contains -- $fields[2] $mainline && continue
        else
            set -l cherry (git cherry $upstream $branch) || continue
            string match -q -- '+*' $cherry && continue
        end

        # Git refuses to remove worktrees with modified or untracked files,
        # the branch is kept then. Ignored files are removed with the worktree.
        if test -n "$worktree"
            git worktree remove $worktree || continue
        end
        git branch -D $branch
    end

    echo
    git branch
end
