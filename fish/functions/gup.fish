# Update branch from remote
function gup
    git fetch $argv && git merge $argv/(gldb) && gp && gl
end
