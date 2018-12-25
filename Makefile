GIT := git
CURL := curl -sL
CRONTAB := crontab
LN := ln -sfn

.SILENT:
.PHONY: install update upgrade

all: install

crontab:
	echo '0 * * * * cd ~/.dotfiles && make update 2>&1 >> /dev/null' > /tmp/crontab
	$(CRONTAB) /tmp/crontab
	rm /tmp/crontab
	$(CRONTAB) -l

install:
	touch ~/.hushlogin
	mkdir -p ~/.config/fish ~/.local/share/fonts
	$(LN) "$$PWD"/alacritty ~/.config/alacritty
	$(LN) "$$PWD"/clang/clang-format ~/.clang-format
	$(LN) "$$PWD"/ccache ~/.ccache
	$(LN) "$$PWD"/compton/compton.conf ~/.compton.conf
	$(LN) "$$PWD"/dunst ~/.config/dunst
	$(LN) "$$PWD"/fish/aliases.fish ~/.config/fish/aliases.fish
	$(LN) "$$PWD"/fish/config.fish ~/.config/fish/config.fish
	$(LN) "$$PWD"/fish/completions ~/.config/fish/
	$(LN) "$$PWD"/gdb/gdbinit ~/.gdbinit
	$(LN) "$$PWD"/ghci/ghci ~/.ghci
	$(LN) "$$PWD"/git/gitconfig ~/.gitconfig
	$(LN) "$$PWD"/git/gitignore_global ~/.gitignore_global
	$(LN) "$$PWD"/hexchat ~/.config/hexchat
	$(LN) "$$PWD"/htop ~/.config/htop
	$(LN) "$$PWD"/i3 ~/.i3
	$(LN) "$$PWD"/fonts/Meslo\ LG\ S\ DZ\ Regular\ Nerd\ Font\ Complete.otf ~/.local/share/fonts/
	$(LN) "$$PWD"/osc ~/.config/osc
	$(LN) "$$PWD"/ranger ~/.config/ranger
	$(LN) "$$PWD"/rustfmt/rustfmt.toml ~/.rustfmt.toml
	$(LN) "$$PWD"/tig/tigrc ~/.tigrc
	$(LN) "$$PWD"/tmux/tmux.conf ~/.tmux.conf
	$(LN) "$$PWD"/vim ~/.vim
	$(LN) "$$PWD"/x11/Xdefaults ~/.Xdefaults
	$(LN) "$$PWD"/x11/profile ~/.profile
	$(LN) "$$PWD"/x11/xinitrc ~/.xinitrc
	echo "Done"

update:
	$(GIT) pull --rebase --autostash

upgrade: update
	$(CURL) https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S-DZ/complete/Meslo%20LG%20S%20DZ%20Regular%20Nerd%20Font%20Complete.otf \
		-o "fonts/Meslo LG S DZ Regular Nerd Font Complete.otf"
	$(CURL) https://github.com/cyrus-and/gdb-dashboard/raw/master/.gdbinit \
		-o gdb/gdbinit
	$(CURL) https://github.com/evanlucas/fish-kubectl-completions/raw/master/kubectl.fish \
		-o fish/completions/kubectl.fish
	$(GIT) add -A
	$(GIT) diff-index --quiet HEAD || $(GIT) commit -m "Upgraded external dependencies"
	$(GIT) push
