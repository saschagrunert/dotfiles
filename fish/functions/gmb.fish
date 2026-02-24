# Get merge base with default branch
function gmb
    git merge-base origin/(gldb) (git rev-parse --abbrev-ref HEAD)
end
