set -gx BROWSER google-chrome-stable
set -gx TERMINAL alacritty
set -gx GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set -gx DOTFILES ~/.dotfiles
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
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

# Everything below only matters for interactive shells
status is-interactive || return

source (status dirname)/aliases.fish

function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l red (set_color ff5555)
    set -l purple (set_color bd93f9)
    set -l blue (set_color 8be9fd)
    set -l yellow (set_color f1fa8c)

    set -l prompt "> "
    set -l prompt_color

    switch $fish_bind_mode
        case default
            set prompt_color $blue $prompt
        case visual
            set prompt_color $yellow $prompt
        case '*'
            test $last_status = 0 && set prompt_color $purple $prompt || set prompt_color $red $prompt
    end

    echo -n -s $prompt_color $normal
end

function fish_greeting
end
function fish_title
end
function fish_mode_prompt
end

# Sets global variables only, so it has to run in every shell (about 5ms)
fish_config theme choose Dracula

function fish_user_key_bindings
    fish_vi_key_bindings
    bind -M insert \ca beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \cp up-or-search
    bind -M insert \cn down-or-search
    if command -q fzf
        source (path resolve (command -v fzf) | path dirname)/../share/fzf/key-bindings.fish
        fzf_key_bindings
        bind -M insert \cg fzf-cd-widget
    end
end

set -g fish_cursor_default block
set -g fish_cursor_insert block

# Generated shell integrations, cached and keyed on the tool binary path. Use
# builtins (path resolve, read), since each external process costs startup time.
# Caches are written to a temporary file first, so a failed or concurrent
# generation never leaves a partial file with a valid header.
set -l _fish_cache ~/.cache/fish
set -q XDG_CACHE_HOME && set _fish_cache $XDG_CACHE_HOME/fish

set -l _zoxide_cache $_fish_cache/zoxide.fish
if command -q zoxide
    set -l _zoxide_bin (path resolve (command -v zoxide))
    if not test -f $_zoxide_cache; or not read -l _header <$_zoxide_cache; or test "$_header" != "# $_zoxide_bin"
        mkdir -p $_fish_cache
        begin
            echo "# $_zoxide_bin"
            zoxide init fish --cmd j
        end >$_zoxide_cache.$fish_pid
        and mv $_zoxide_cache.$fish_pid $_zoxide_cache
        or rm -f $_zoxide_cache.$fish_pid
    end
    test -f $_zoxide_cache && source $_zoxide_cache
end

# kubectl completions are large, so write them where fish autoloads them on the
# first completion instead of sourcing them at startup
set -l _kubectl_completions $__fish_user_data_dir/vendor_completions.d/kubectl.fish
if command -q kubectl
    set -l _kubectl_bin (path resolve (command -v kubectl))
    if not test -f $_kubectl_completions; or not read -l _header <$_kubectl_completions; or test "$_header" != "# $_kubectl_bin"
        mkdir -p (path dirname $_kubectl_completions)
        begin
            echo "# $_kubectl_bin"
            kubectl completion fish
        end >$_kubectl_completions.$fish_pid
        and mv $_kubectl_completions.$fish_pid $_kubectl_completions
        or rm -f $_kubectl_completions.$fish_pid
    end
end

source (status dirname)/functions/kubernetes.fish
