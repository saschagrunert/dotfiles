# Used binaries
GIT := git
CURL := curl -sfL
# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
GIT_USER := Sascha Grunert
EMAIL := sgrunert@redhat.com
SIGNKEY := 79C3DE73D9F8B626A81B990109D97D153EF94D93

# Colors
COLOR := \033[36m
NOCOLOR := \033[0m

.SILENT:
.PHONY: all build switch gitconfig-user update upgrade check check-nix lint lint-fix test help

##@ Build targets:

all: switch ## Build and switch to the NixOS configuration (default).

build: ## Build the NixOS configuration.
	nixos-rebuild build --flake .\#nixos

switch: ## Build and switch to the NixOS configuration.
	sudo nixos-rebuild switch --flake .\#nixos

##@ Setup targets:

gitconfig-user: ## Generate the user-specific gitconfig.
	rm -f $(GITCONFIG_USER_PATH)
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.name "$(GIT_USER)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.email "$(EMAIL)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.signkey "$(SIGNKEY)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) commit.gpgsign true
	echo '# vi: syn=gitconfig' >> $(GITCONFIG_USER_PATH)

##@ Validation targets:

check: ## Check symlinks and required commands.
	@fail=0; \
	echo "Checking symlinks..."; \
	for f in $$(find ~ -maxdepth 3 -type l 2>/dev/null | sort); do \
		target=$$(readlink "$$f"); \
		case "$$target" in *home-manager-files*) \
			if [ -e "$$f" ]; then \
				echo "  OK: $$f"; \
			else \
				echo "  BROKEN: $$f -> $$target"; \
				fail=1; \
			fi ;; \
		esac; \
	done; \
	echo "Checking commands..."; \
	for cmd in nix fish sway git; do \
		if command -v $$cmd >/dev/null 2>&1; then \
			echo "  OK: $$cmd"; \
		else \
			echo "  MISSING: $$cmd"; \
			fail=1; \
		fi; \
	done; \
	exit $$fail

check-nix: ## Run nix flake checks.
	nix flake check

lint: ## Check formatting and lint all Nix files.
	nix shell nixpkgs\#nixfmt -c nixfmt --check $$(find . -name '*.nix')
	nix shell nixpkgs\#statix -c statix check .
	nix shell nixpkgs\#deadnix -c deadnix --fail $$(find . -name '*.nix')

lint-fix: ## Fix formatting and lint issues in all Nix files.
	nix shell nixpkgs\#nixfmt -c nixfmt $$(find . -name '*.nix')
	nix shell nixpkgs\#statix -c statix fix .
	nix shell nixpkgs\#deadnix -c deadnix -e $$(find . -name '*.nix')

test: lint check-nix ## Run checks locally.
	npx prettier@3 --check .
	nix shell nixpkgs\#typos -c typos
	nix shell nixpkgs\#shfmt -c shfmt -d .
	nix shell nixpkgs\#shellcheck -c shellcheck $$(find . -name '*.sh') sway/power sway/temps sway/workspace-scroll
	nix shell nixpkgs\#shellcheck -c sh -c 'find tmux/scripts -type f -not -name "*.sh" | xargs shellcheck'
	nix shell nixpkgs\#fish -c fish --no-execute $$(find . -name '*.fish' ! -name 'fzf_key_bindings.fish')

##@ Update targets:

update: ## Pull the latest changes from remote.
	$(GIT) pull --rebase --autostash

upgrade: update ## Update and upgrade external dependencies.
	$(CURL) https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
		-o gdb/gdbinit
	$(CURL) https://raw.githubusercontent.com/evanlucas/fish-kubectl-completions/refs/heads/main/completions/kubectl.fish \
		-o fish/completions/kubectl.fish
	$(CURL) https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.fish \
		-o fish/functions/fzf_key_bindings.fish
	$(CURL) https://raw.githubusercontent.com/dracula/sublime/master/Dracula.tmTheme \
		-o bat/themes/Dracula.tmTheme
	$(GIT) add \
		gdb/gdbinit \
		fish/completions/kubectl.fish \
		fish/functions/fzf_key_bindings.fish \
		bat/themes/Dracula.tmTheme
	$(GIT) diff-index --quiet HEAD || $(GIT) commit -sm "Upgraded external dependencies"

##@ Help:

help: ## Display this help.
	@awk \
		-v "col=$(COLOR)" -v "nocol=$(NOCOLOR)" \
		' \
			BEGIN { \
				FS = ":.*##" ; \
				printf "Usage:\n  make %s<target>%s\n", col, nocol \
			} \
			/^[a-zA-Z_-]+:.*?##/ { \
				printf "  %s%-30s%s %s\n", col, $$1, nocol, $$2 \
			} \
			/^##@/ { \
				printf "\n%s\n", substr($$0, 5) \
			} \
		' $(MAKEFILE_LIST)
