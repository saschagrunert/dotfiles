set -x TERM xterm-256color
set -x VISUAL vim
set -x EDITOR vim
set -x GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set -x QT_STYLE_OVERRIDE gtk2
set -x MAN_POSIXLY_CORRECT 1

#if test -z "$LD_LIBRARY_PATH"
#    set -x LD_LIBRARY_PATH (nix eval --raw nixpkgs\#stdenv.cc.cc.lib)/lib
#    set -a LD_LIBRARY_PATH /run/current-system/sw/lib
#end

if test -z $PROTOC
    set -x PROTOC (command -v protoc)
end

if test -d $HOME/go
    set -x GOPATH $HOME/go
    set -x GOBIN $GOPATH/bin
    set -a __my_path $GOBIN
end

if test -d $HOME/.cargo/bin
    set -a __my_path $HOME/.cargo/bin
end

if test -d $HOME/.krew/bin
    set -a __my_path $HOME/.krew/bin
end

if test -d $HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin
    set -a __my_path $HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin
end

if test -d $HOME/.local/bin
    set -a __my_path $HOME/.local/bin
end

if test -d $HOME/.npm-global/bin
    set -a __my_path $HOME/.npm-global/bin
end

# Only update fish_user_paths if it has changed to avoid unnecessary universal variable writes
if not test "$__my_path" = "$fish_user_paths"
    set -U fish_user_paths $__my_path
end

source $HOME/.config/fish/aliases.fish

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

    if functions -q fish_vi_key_bindings
        switch $fish_bind_mode
            case default
                set vi_mode $blue $nprompt
            case visual
                set vi_mode $yellow $vprompt
            case '*'
                if test $last_status = 0
                    set vi_mode $purple $iprompt
                else
                    set vi_mode $red $iprompt
                end
        end
    end

    if test $last_status = 0
        set arrow $purple $iprompt
    else
        set arrow $red $iprompt
    end

    if functions -q fish_vi_key_bindings
        echo -n -s $vi_mode $normal
    else
        echo -n -s $arrow $normal
    end
end

function fish_greeting; end
function fish_title; end
function fish_mode_prompt; end

# Only set colors if not already set (avoid unnecessary universal variable writes)
if not set -q fish_color_normal
    set -U fish_color_normal normal
    set -U fish_color_command 8be9fd
    set -U fish_color_quote f1fa8c
    set -U fish_color_redirection ffb86c
    set -U fish_color_end 50fa7b
    set -U fish_color_error ff5555
    set -U fish_color_param f8f8f2
    set -U fish_color_comment 6272a4
    set -U fish_color_match 8be9fd
    set -U fish_color_search_match --background=44475a
    set -U fish_color_operator 50fa7b
    set -U fish_color_escape bd93f9
    set -U fish_color_cwd bd93f9
    set -U fish_color_cwd_root ff5555
    set -U fish_color_autosuggestion 6272a4
    set -U fish_color_history_current 8be9fd
    set -U fish_color_host -o 8be9fd
    set -U fish_color_status ff5555
    set -U fish_color_valid_path normal
    set -U fish_color_selection --background=44475a
    set -U fish_pager_color_completion f8f8f2
    set -U fish_pager_color_description 808080
    set -U fish_pager_color_prefix ffb86c
    set -U fish_pager_color_progress 50fa7b
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
test -f $HOME/.config/fish/functions/autojump.fish; and source $HOME/.config/fish/functions/autojump.fish
test -f $HOME/.config/fish/functions/kubernetes.fish; and source $HOME/.config/fish/functions/kubernetes.fish
