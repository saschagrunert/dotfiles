# Fetch and checkout GitHub PR
function gpr
    test (count $argv) -eq 2 || return 1
    git fetch $argv[1] pull/$argv[2]/head:pr-$argv[2] && git checkout pr-$argv[2]
end
