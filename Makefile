# Used binaries
GIT := git
NIX_SHELL := nix shell
# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
GIT_USER := Sascha Grunert
EMAIL := sgrunert@redhat.com
SIGNKEY := 79C3DE73D9F8B626A81B990109D97D153EF94D93

# Files
NIX_FILES := $(shell find . -name '*.nix' -not -path './.git/*')
FISH_FILES := $(shell find . -name '*.fish' -not -path './.git/*')
SHELL_FILES := $(shell find . -name '*.sh' -not -path './.git/*') \
	$(shell find tmux/scripts -type f -not -name '*.sh') \
	sway/dnd sway/power sway/temps sway/workspace-scroll

# Colors
COLOR := \033[36m
NOCOLOR := \033[0m

.SILENT:
.PHONY: all build switch gitconfig-user check check-nix lint lint-fix \
	markdown-lint prettier typos shfmt fish-lint lua-lint test clean help

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
	$(NIX_SHELL) nixpkgs\#nixfmt nixpkgs\#statix nixpkgs\#deadnix -c bash -c \
		'nixfmt --check $(NIX_FILES) && statix check . && deadnix --fail $(NIX_FILES)'

lint-fix: ## Fix formatting and lint issues in all Nix files.
	$(NIX_SHELL) nixpkgs\#nixfmt nixpkgs\#statix nixpkgs\#deadnix -c bash -c \
		'nixfmt $(NIX_FILES) && statix fix . && deadnix -e $(NIX_FILES)'

markdown-lint: ## Lint all markdown files.
	$(NIX_SHELL) nixpkgs\#markdownlint-cli2 -c markdownlint-cli2 '**/*.md'

prettier: ## Check formatting with prettier.
	npx --yes prettier@3 --check .

typos: ## Check for typos.
	$(NIX_SHELL) nixpkgs\#typos -c typos

shfmt: ## Check shell script formatting and lint.
	$(NIX_SHELL) nixpkgs\#shfmt nixpkgs\#shellcheck -c bash -c \
		'shfmt -d . && shellcheck $(SHELL_FILES)'

fish-lint: ## Check fish syntax and formatting.
	$(NIX_SHELL) nixpkgs\#fish -c bash -c \
		'for f in $(FISH_FILES); do fish --no-execute "$$f" || exit 1; done && fish_indent --check $(FISH_FILES)'

lua-lint: ## Check Lua formatting and lint.
	$(NIX_SHELL) nixpkgs\#stylua nixpkgs\#luajitPackages.luacheck -c bash -c \
		'stylua --check nvim/ && luacheck nvim/'

test: lint check-nix markdown-lint prettier typos shfmt fish-lint lua-lint ## Run all checks.

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
