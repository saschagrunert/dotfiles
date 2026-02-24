set -gx VISUAL vim
set -gx EDITOR vim
set -gx GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set -gx DOTFILES ~/.dotfiles
set -gx QT_STYLE_OVERRIDE gtk2
set -gx MAN_POSIXLY_CORRECT 1

if test -d ~/go
    set -gx GOPATH ~/go
    set -gx GOBIN $GOPATH/bin
    fish_add_path --path --move $GOBIN
end

test -d ~/.cargo/bin && fish_add_path --path --move ~/.cargo/bin
test -d ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin && fish_add_path --path --move ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin
test -d ~/.local/bin && fish_add_path --path --move ~/.local/bin
test -d ~/.npm-global/bin && fish_add_path --path --move ~/.npm-global/bin

source ~/.config/fish/aliases.fish

function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l red (set_color ff5555)
    set -l purple (set_color bd93f9)
    set -l blue (set_color 8be9fd)
    set -l yellow (set_color f1fa8c)

    set -l iprompt "> "
    set -l nprompt "> "
    set -l vprompt "> "
    set -l prompt_color

    if functions -q fish_vi_key_bindings
        switch $fish_bind_mode
            case default
                set prompt_color $blue $nprompt
            case visual
                set prompt_color $yellow $vprompt
            case '*'
                test $last_status = 0 && set prompt_color $purple $iprompt || set prompt_color $red $iprompt
        end
    else
        test $last_status = 0 && set prompt_color $purple $iprompt || set prompt_color $red $iprompt
    end

    echo -n -s $prompt_color $normal
end

function fish_greeting; end
function fish_title; end
function fish_mode_prompt; end

fish_config theme choose "Dracula"

if functions -q fish_vi_key_bindings
    function fish_user_key_bindings
        fish_vi_key_bindings
        bind -M insert \ca beginning-of-line
        bind -M insert \ce end-of-line
        bind -M insert \cp up-or-search
        bind -M insert \cn down-or-search
        fzf_key_bindings
        bind -M insert \cg fzf-cd-widget
    end
end

set -g fish_cursor_default block
set -g fish_cursor_insert block

# Source optional functions only if they exist
test -f ~/.config/fish/functions/autojump.fish && source ~/.config/fish/functions/autojump.fish
test -f ~/.config/fish/functions/kubernetes.fish && source ~/.config/fish/functions/kubernetes.fish
