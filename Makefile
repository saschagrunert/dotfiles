# Used binaries
GIT := git
CURL := curl -sfL
NIX_SHELL := nix shell
# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
GIT_USER := Sascha Grunert
EMAIL := sgrunert@redhat.com
SIGNKEY := 79C3DE73D9F8B626A81B990109D97D153EF94D93

# Files
NIX_FILES := $(shell find . -name '*.nix' -not -path './.git/*')
FISH_FILES := $(shell find . -name '*.fish' -not -path './.git/*' ! -name 'fzf_key_bindings.fish')
SHELL_FILES := $(shell find . -name '*.sh' -not -path './.git/*') \
	$(shell find tmux/scripts -type f -not -name '*.sh') \
	sway/dnd sway/power sway/temps sway/workspace-scroll

# Colors
COLOR := \033[36m
NOCOLOR := \033[0m

.SILENT:
.PHONY: all build switch gitconfig-user update upgrade check check-nix lint lint-fix \
	markdown-lint prettier typos shfmt shellcheck fish-lint lua-lint test clean help

##@ Build targets:

all: switch ## Build and switch to the NixOS configuration (default).

build: ## Build the NixOS configuration.
	nixos-rebuild build --flake .\#nixos

switch: ## Build and switch to the NixOS configuration.
	sudo nixos-rebuild switch --flake .\#nixos

##@ Setup targets:

gitconfig-user: ## Generate the user-specific gitconfig (keeps other settings in the file).
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.name "$(GIT_USER)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.email "$(EMAIL)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.signkey "$(SIGNKEY)"
	grep -q '^# vi: syn=gitconfig' $(GITCONFIG_USER_PATH) || \
		echo '# vi: syn=gitconfig' >> $(GITCONFIG_USER_PATH)

##@ Validation targets:

check: ## Check symlinks and required commands.
	fail=0; \
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
	$(NIX_SHELL) nixpkgs\#nixfmt -c nixfmt --check $(NIX_FILES)
	$(NIX_SHELL) nixpkgs\#statix -c statix check .
	$(NIX_SHELL) nixpkgs\#deadnix -c deadnix --fail $(NIX_FILES)

lint-fix: ## Fix formatting and lint issues in all Nix files.
	$(NIX_SHELL) nixpkgs\#nixfmt -c nixfmt $(NIX_FILES)
	$(NIX_SHELL) nixpkgs\#statix -c statix fix .
	$(NIX_SHELL) nixpkgs\#deadnix -e $(NIX_FILES)

markdown-lint: ## Lint all markdown files.
	$(NIX_SHELL) nixpkgs\#markdownlint-cli2 -c markdownlint-cli2 '**/*.md'

prettier: ## Check formatting with prettier.
	npx --yes prettier@3 --check .

typos: ## Check for typos.
	$(NIX_SHELL) nixpkgs\#typos -c typos

shfmt: ## Check shell script formatting.
	$(NIX_SHELL) nixpkgs\#shfmt -c shfmt -d .

shellcheck: ## Lint shell scripts.
	$(NIX_SHELL) nixpkgs\#shellcheck -c shellcheck $(SHELL_FILES)

fish-lint: ## Check fish syntax and formatting.
	for f in $(FISH_FILES); do \
		$(NIX_SHELL) nixpkgs\#fish -c fish --no-execute "$$f" || exit 1; \
	done
	$(NIX_SHELL) nixpkgs\#fish -c fish_indent --check $(FISH_FILES)

lua-lint: ## Check Lua formatting and lint.
	$(NIX_SHELL) nixpkgs\#stylua -c stylua --check nvim/
	$(NIX_SHELL) nixpkgs\#luajitPackages.luacheck -c luacheck nvim/

test: lint check-nix markdown-lint prettier typos shfmt shellcheck fish-lint lua-lint ## Run all checks locally.

##@ Update targets:

update: ## Pull the latest changes from remote.
	$(GIT) pull --rebase --autostash

upgrade: update ## Update and upgrade external dependencies.
	$(CURL) https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
		-o gdb/gdbinit
	$(CURL) https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.fish \
		-o fish/functions/fzf_key_bindings.fish
	sed -i '/^# Run setup/,$$d' fish/functions/fzf_key_bindings.fish
	$(CURL) https://raw.githubusercontent.com/dracula/sublime/master/Dracula.tmTheme \
		-o bat/themes/Dracula.tmTheme
	$(GIT) add \
		gdb/gdbinit \
		fish/functions/fzf_key_bindings.fish \
		bat/themes/Dracula.tmTheme
	$(GIT) diff-index --cached --quiet HEAD || $(GIT) commit -sm "Upgraded external dependencies"

##@ Cleanup targets:

clean: ## Remove build results.
	rm -f result

##@ Help:

help: ## Display this help.
	awk \
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
