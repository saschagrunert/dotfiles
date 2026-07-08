# Remove remote branch and prune local
function grm
    for branch in $argv
        git push origin :$branch
    end
    gpl
end
