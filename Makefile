# Used binaries
GIT := git
CURL := curl -sfL
# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
USER := Sascha Grunert
EMAIL := sgrunert@redhat.com
SIGNKEY := 79C3DE73D9F8B626A81B990109D97D153EF94D93

.SILENT:
.PHONY: all build switch gitconfig-user update upgrade check

all: gitconfig-user

build:
	nixos-rebuild build --flake $(CURDIR)\#nixos

switch:
	sudo nixos-rebuild switch --flake $(CURDIR)\#nixos

gitconfig-user:
	rm -f $(GITCONFIG_USER_PATH)
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.name "$(USER)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.email "$(EMAIL)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.signkey "$(SIGNKEY)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) commit.gpgsign true
	echo '# vi: syn=gitconfig' >> $(GITCONFIG_USER_PATH)

check:
	@echo "Checking symlinks..."
	@for f in ~/.gdbinit ~/.gitconfig ~/.tmux.conf ~/.vim; do \
		if [ -L "$$f" ]; then \
			echo "  OK: $$f -> $$(readlink $$f)"; \
		else \
			echo "  MISSING: $$f"; \
		fi; \
	done
	@echo "Checking commands..."
	@for cmd in nix fish i3 git; do \
		if command -v $$cmd >/dev/null 2>&1; then \
			echo "  OK: $$cmd"; \
		else \
			echo "  MISSING: $$cmd"; \
		fi; \
	done

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
	$(GIT) add \
		gdb/gdbinit \
		fish/completions/kubectl.fish \
		fish/functions/fzf_key_bindings.fish \
		bat/themes/Dracula.tmTheme \
		fish/functions/autojump.fish
	$(GIT) diff-index --quiet HEAD || $(GIT) commit -sm "Upgraded external dependencies"
