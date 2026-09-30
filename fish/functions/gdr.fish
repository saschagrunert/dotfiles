# Get the remote holding the default branch: base in forks once it has been
# fetched, origin otherwise
function gdr
    if git for-each-ref --count=1 --format=x refs/remotes/base/ 2>/dev/null | string match -q x
        echo base
    else
        echo origin
    end
end
