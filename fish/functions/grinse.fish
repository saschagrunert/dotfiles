# Deep clean git repo and submodules
function grinse
    echo "This will destroy all uncommitted changes. Continue? [y/N]"
    read -l confirm
    test "$confirm" = y || test "$confirm" = Y || return 1
    git clean -xfd
    and git submodule foreach --recursive git clean -xfd
    and git reset --hard
    and git submodule foreach --recursive git reset --hard
    and git submodule update --init --recursive
end
