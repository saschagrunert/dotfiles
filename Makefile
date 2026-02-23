# Used binaries
GIT := git
CURL := curl -sL
# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
USER := Sascha Grunert
EMAIL := sgrunert@redhat.com
SIGNKEY := 79C3DE73D9F8B626A81B990109D97D153EF94D93

.SILENT:
.PHONY: all switch gitconfig-user update upgrade

all: gitconfig-user

switch:
	sudo nixos-rebuild switch --flake ~/.dotfiles\#nixos

gitconfig-user:
	rm -f $(GITCONFIG_USER_PATH)
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.name "$(USER)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.email "$(EMAIL)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.signkey "$(SIGNKEY)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) commit.gpgsign true
	echo '# vi: syn=gitconfig' >> $(GITCONFIG_USER_PATH)

update:
	$(GIT) pull --rebase --autostash

upgrade: update
	$(CURL) https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
		-o gdb/gdbinit
	$(CURL) https://raw.githubusercontent.com/evanlucas/fish-kubectl-completions/refs/heads/main/completions/kubectl.fish \
		-o fish/completions/kubectl.fish
	$(CURL) https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.fish \
		-o fish/functions/fzf_key_bindings.fish
	$(CURL) https://raw.githubusercontent.com/dracula/sublime/master/Dracula.tmTheme \
		-o bat/themes/Dracula.tmTheme
	$(CURL) https://raw.githubusercontent.com/wting/autojump/master/bin/autojump.fish \
		-o fish/functions/autojump.fish
	$(GIT) add -A
	$(GIT) diff-index --quiet HEAD || $(GIT) commit -sm "Upgraded external dependencies"
