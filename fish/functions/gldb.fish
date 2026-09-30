# Get the default branch of remote $argv[1], or of the default remote. Only a
# clone or `git remote set-head` sets the remote HEAD, so without it the usual
# names are tried on that remote.
function gldb
    set -l remote $argv[1]
    test -n "$remote" || set remote (gdr)
    set -l branch (git symbolic-ref refs/remotes/$remote/HEAD 2>/dev/null | string replace -r '.+/' '')
    if test -n "$branch"
        echo $branch
        return
    end
    for branch in main master
        if git rev-parse -q --verify refs/remotes/$remote/$branch >/dev/null 2>&1
            echo $branch
            return
        end
    end
    echo main
end
