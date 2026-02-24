# List changed files against default branch
function gdifff
    git diff --name-only origin/(gldb)...(git rev-parse --abbrev-ref HEAD)
end
