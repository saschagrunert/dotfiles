# Make directory and cd into it
function mdc
    test (count $argv) -eq 1 || begin
        echo "Usage: mdc <directory>" >&2
        return 1
    end
    mkdir -p "$argv[1]" && cd "$argv[1]"
end
