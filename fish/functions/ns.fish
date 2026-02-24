# Run command in nix dev shell
function ns
    if test (count $argv) -gt 0
        nix develop $DOTFILES --command $argv
    else
        nix develop $DOTFILES --command fish
    end
end
