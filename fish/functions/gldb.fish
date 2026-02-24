# Get local default branch
function gldb
    git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | cut -d/ -f4
end
