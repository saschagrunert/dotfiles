# List changed files against default branch
function gdifff
    git diff --name-only (gdr)/(gldb)...
end
