alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
command -q bat && abbr -a cat bat
command -q eza && alias ls "eza --git -bg --classify=always"

abbr -a cl claude
abbr -a dush du -sh \*
abbr -a f fd
abbr -a ff fd --type f
abbr -a g git
abbr -a ga git add
abbr -a gaa git add -A
abbr -a gb git branch
abbr -a gba git branch -a
abbr -a gbv git branch -vv
abbr -a gca git commit -s --amend
abbr -a gcan git commit -s --amend --no-edit
abbr -a gcaa git commit -s -a --amend --no-edit
abbr -a gcl git clone
abbr -a gcmsg git commit -sm
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gdc git diff --cached
abbr -a glg git log --stat --max-count=10
abbr -a glgg git log --graph --max-count=10
abbr -a glgga git log --graph --decorate --all
abbr -a glo git log --oneline --decorate --color
abbr -a glog git log --oneline --decorate --color --graph
abbr -a glr git pull --rebase
abbr -a gm git merge
abbr -a gmn git merge --no-ff
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a gr git reset .
abbr -a grc git rebase --continue
abbr -a grup git remote update
abbr -a gupb gup base
abbr -a grv git remote -v
abbr -a gsp git stash pop
abbr -a gss git stash
abbr -a gst git status
abbr -a ghn gh api -X PUT notifications --silent
abbr -a h history
abbr -a hs history --search
abbr -a k kubectl
abbr -a kk kubectl config use-context
abbr -a l ls -l
abbr -a la ls -a
abbr -a ll ls -la
abbr -a llt ls -laT
abbr -a lt ls -lT
abbr -a m make
abbr -a mc make clean
abbr -a md mkdir -p
abbr -a mm "make -j(nproc)"
abbr -a nup nix flake update --flake \$DOTFILES
abbr -a p pwd
abbr -a po popd
abbr -a pu pushd
abbr -a rup rustup update
abbr -a screensleep xset dpms force off
abbr -a t tail -f
abbr -a ta tmux attach
abbr -a tg cd \~ \&\& tmux
abbr -a tl tmux list-sessions
abbr -a ts tmux new-session -s
abbr -a up rustup update \&\& sudo nixos-rebuild switch --flake \$DOTFILES\#nixos \&\& nix develop \$DOTFILES --command true \&\& nix-collect-garbage --delete-older-than 7d
abbr -a v nvim
abbr -a vr ranger
abbr -a vv nvim -u NONE
