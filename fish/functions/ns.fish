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

complete -c ns -f -a '(
    set -l tokens (commandline -opc)
    set -l subcmd (string join " " -- $tokens[2..] (commandline -ct))
    if test -z "$subcmd"
        complete -C ""
    else
        complete -C "$subcmd"
    end
)'
