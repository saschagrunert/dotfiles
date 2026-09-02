# Prune local branches that are gone on remote
function gpl
    set -l current (git branch --show-current)
    for branch in (git for-each-ref --format='%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)' refs/heads/ | string match -rv '^$')
        test "$branch" = "$current" && continue
        git branch -D $branch
    end
end
