function c; clear; if test $TMUX; tmux clear-history; end; end
function mdc; mkdir -p $argv; and cd $argv; end
function gldb; git symbolic-ref refs/remotes/origin/HEAD | cut -d/ -f4; end
function gpl; for branch in (git branch -vv | grep ': gone]' | gawk '{print $1}'); git branch -D $branch; end; end
function grm; git push origin :$argv; and gpl; end
function gpr; git fetch $argv[1] pull/$argv[2]/head:pr-$argv[2]; and git checkout pr-$argv[2]; end
function gup; git fetch $argv; and git merge $argv/(gldb); and gp; and gl; end
function kns; kubectl config set-context --current --namespace=$argv; end
function ns; nix-shell ~/.dotfiles/nix-shell --run "$argv"; end
function tailc; watch -n1 'curl -sf "'$argv[1]'" | tail -n $(($(tput lines) - 2))'; end

function nb;
    set -l PKG (basename $PWD)
    if count $argv > /dev/null
        set PKG "$argv"
    end
    nix build "(import <nixpkgs-unstable> { }).$PKG.overrideAttrs (x: { src = ./.; })"
end

function cl
    export ANTHROPIC_VERTEX_PROJECT_ID=itpc-gcp-hybrid-pe-eng-claude
    export CLAUDE_CODE_USE_VERTEX=1
    export CLOUD_ML_REGION=us-east5
    claude
end

alias .. "cd ../"
alias ... "cd ../../"
alias .... "cd ../../../"
alias ..... "cd ../../../../"
alias cat "bat"
alias duf "du -sh *"
alias f "fd"
alias ff "fd --type f"
alias g "git"
alias ga "git add"
alias gaa "git add -A"
alias gb "git branch"
alias gba "git branch -a"
alias gbv "git branch -vv"
alias gca "git commit -s --amend"
alias gcan "git commit -s --amend --no-edit"
alias gcaa "git commit -s -a --amend --no-edit"
alias gcl "git clone"
alias gcm "git checkout (gldb)"
alias gcmsg "git commit -sm"
alias gco "git checkout"
alias gd "git diff"
alias gdc "git diff --cached"
alias gdiff "git difftool origin/(gldb)...(git rev-parse --abbrev-ref HEAD)"
alias gdifff "git diff --name-only origin/(gldb)...(git rev-parse --abbrev-ref HEAD)"
alias gl "git pull --prune;and gpl"
alias glg "git log --stat --max-count=10"
alias glgg "git log --graph --max-count=10"
alias glgga "git log --graph --decorate --all"
alias glo "git log --oneline --decorate --color"
alias glog "git log --oneline --decorate --color --graph"
alias glr "git pull --rebase"
alias gm "git merge"
alias gmb "git merge-base origin/(gldb) (git rev-parse --abbrev-ref HEAD)"
alias gmm "git merge origin/(gldb)"
alias gmn "git merge --no-ff"
alias gp "git push"
alias gpf "git push -f"
alias gr "git reset ."
alias grc "git rebase --continue"
alias gupb "gup base"
alias grinse "git clean -xfd;and git submodule foreach --recursive git clean -xfd; and git reset --hard; git submodule foreach --recursive git reset --hard; and git submodule update --init --recursive"
alias grup "git remote update"
alias grv "git remote -v"
alias gsp "git stash pop"
alias gsq "git reset (gmb); gaa; git commit -s"
alias gss "git stash"
alias gst "git status"
alias gsta "git stash"
alias h "history"
alias hs "history --search"
alias k "kubectl"
alias kk "kubectl config use-context"
alias l "ls -l"
alias la "ls -a"
alias ll "l -a"
alias llt "ll -T"
alias ls "eza --git -bgF"
alias lt "l -T"
alias m "make"
alias mc "make clean"
alias md "mkdir -p"
alias mm "make -j32"
alias nowrap "cut -c-$COLUMNS"
alias nup "nix-channel --update; and nix-env -u '*'"
alias p "pwd"
alias po "popd"
alias pu "pushd"
alias r "rm -rf"
alias rup "rustup update"
alias screensleep "xset dpms force off"
alias t "tail -f"
alias ta "tmux attach"
alias tg "cd ~; and tmux"
alias tl "tmux list-sessions"
alias ts "tmux new-session -s"
alias up "rup && sudo nix-channel --update && sudo nixos-rebuild switch --upgrade"
alias v "vim"
alias vr "ranger"
alias vv "vim -u NONE"
