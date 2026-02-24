# Run claude with local bin path
function cl
    export PATH="$HOME/.local/bin:$PATH"
    claude $argv
end
