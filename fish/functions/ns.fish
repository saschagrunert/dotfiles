# Run command in nix dev shell
function ns
    if not set -q DOTFILES
        echo "DOTFILES not set" >&2
        return 1
    end
    if test (count $argv) -gt 0
        nix develop $DOTFILES --command $argv
    else
        nix develop $DOTFILES --command fish
    end
end
