# Deep clean git repo and submodules
function grinse
    git clean -xfd
    and git submodule foreach --recursive git clean -xfd
    and git reset --hard
    and git submodule foreach --recursive git reset --hard
    and git submodule update --init --recursive
end
