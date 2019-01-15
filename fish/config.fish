set -x TERM xterm-256color
set -x VISUAL vim
set -x EDITOR vim
set -x GIT_DISCOVERY_ACROSS_FILESYSTEM 1
set -x RUST_SRC_PATH $HOME/.multirust/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
set -x QT_STYLE_OVERRIDE gtk2

set -x DOTBIN $HOME/.vim/bin

if test -d $HOME/go
    set -x GOPATH $HOME/go
    set -x GOBIN $GOPATH/bin
end

if test -d $HOME/.cargo/bin
    set -x CARGOBIN $HOME/.cargo/bin
end

if test -d $HOME/.local/bin
    set -x LOCALBIN $HOME/.local/bin
end

if test -d /usr/lib64/ccache
    set -x CCACHEBIN /usr/lib64/ccache
end

if test -d /usr/local/sbin
    set -x LOCALSBIN /usr/local/sbin
end

if test -d /usr/sbin
    set -x SBIN /usr/sbin
end

set -U fish_user_paths $CCACHEBIN $DOTBIN $CARGOBIN $GOBIN $HOMEBIN $LOCALBIN $LOCALSBIN $SBIN

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

source $HOME/.config/fish/functions/autojump.fish
