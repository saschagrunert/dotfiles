# Fetch and checkout GitHub PR
function gpr
    test (count $argv) -eq 2 || begin
        echo "Usage: gpr <remote> <pr-number>" >&2
        return 1
    end
    set -l branch pr-$argv[2]
    # Fetch into FETCH_HEAD, since git refuses to fetch into the checked-out branch
    git fetch $argv[1] pull/$argv[2]/head || return
    if test "$(git branch --show-current)" = $branch
        # Only fast-forward the checked-out branch, so local commits are kept
        git merge --ff-only FETCH_HEAD || begin
            echo "Cannot fast-forward $branch (local commits or force-pushed PR). To reset: git reset --hard FETCH_HEAD" >&2
            return 1
        end
    else
        # An existing pr-N is only moved forward, so local commits are kept
        if git rev-parse -q --verify refs/heads/$branch >/dev/null
            and not git merge-base --is-ancestor $branch FETCH_HEAD
            echo "Cannot fast-forward $branch (local commits or force-pushed PR). To reset: git checkout -B $branch FETCH_HEAD" >&2
            return 1
        end
        git checkout -B $branch FETCH_HEAD
    end
end
