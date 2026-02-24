# Clear terminal and tmux history
function c
    clear
    test -n "$TMUX" && tmux clear-history
end
