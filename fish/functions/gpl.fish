# Prune local branches that are gone on remote
function gpl
    for branch in (git branch -vv | grep ': gone]' | gawk '{print $1}')
        git branch -D $branch
    end
end
