# Difftool against default branch
function gdiff
    git difftool (gdr)/(gldb)...(git rev-parse --abbrev-ref HEAD)
end
