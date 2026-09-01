set -gx BROWSER google-chrome-stable
set -gx TERMINAL alacritty
set -gx GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set -gx DOTFILES ~/.dotfiles
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "bat -l man -p"
set -gx FZF_DEFAULT_OPTS "\
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
    --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 \
    --border --layout=reverse"
set -gx FZF_CTRL_T_COMMAND "fd --type f --hidden --follow --exclude .git"
set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || head -200 {}'"
set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"

if test -d ~/go
    set -gx GOPATH ~/go
    set -gx GOBIN $GOPATH/bin
    fish_add_path --path --move $GOBIN
end

test -d ~/.cargo/bin && fish_add_path --path --move ~/.cargo/bin
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

if not set -q __fish_theme_configured
    fish_config theme choose "Dracula"
    set -U __fish_theme_configured 1
end

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
if command -q zoxide
    zoxide init fish --cmd j | source
end
if command -q direnv
    direnv hook fish | source
end
test -f ~/.config/fish/functions/kubernetes.fish && source ~/.config/fish/functions/kubernetes.fish
