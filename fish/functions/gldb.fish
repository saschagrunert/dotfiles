# Get local default branch
function gldb
    set -l branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace -r '.+/' '')
    test -n "$branch" && echo $branch || echo main
end
