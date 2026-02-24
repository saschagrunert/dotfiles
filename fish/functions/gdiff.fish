# Difftool against default branch
function gdiff
    git difftool origin/(gldb)...(git rev-parse --abbrev-ref HEAD)
end
