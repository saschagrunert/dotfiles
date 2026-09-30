# List changed files against default branch
function gdifff
    git diff --name-only (gdr)/(gldb)...(git rev-parse --abbrev-ref HEAD)
end
