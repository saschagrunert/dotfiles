# Get merge base with default branch
function gmb
    git merge-base (gdr)/(gldb) (git rev-parse --abbrev-ref HEAD)
end
