# Fetch and checkout GitHub PR
function gpr
    test (count $argv) -eq 2 || begin
        echo "Usage: gpr <remote> <pr-number>" >&2
        return 1
    end
    git fetch $argv[1] pull/$argv[2]/head:pr-$argv[2] && git checkout pr-$argv[2]
end
