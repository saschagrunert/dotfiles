# Clear terminal and tmux history
function c
    clear
    # Guarded instead of "&&", so the function does not return non-zero (and
    # paint the next prompt red) when running outside tmux.
    if test -n "$TMUX"
        tmux clear-history
    end
end
