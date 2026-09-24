# Used binaries
GIT := git
# Resolve nixpkgs from flake.lock, so local runs and CI use the same tool versions
NIX_SHELL := nix shell --inputs-from .
# The flake attribute to build and switch to
HOST := nixos
# Paths
GITCONFIG_USER_PATH := ~/.gitconfig_user

# User specific settings
GIT_USER := Sascha Grunert
EMAIL := sgrunert@redhat.com
SIGNKEY := 79C3DE73D9F8B626A81B990109D97D153EF94D93

# Files. Shell scripts are matched by shebang inside the shellcheck recipe, so
# extensionless helpers are covered without listing them here (a literal # can
# not appear in a Makefile variable assignment).
NIX_FILES := $(shell find . -name '*.nix' -not -path './.git/*')
FISH_FILES := $(shell find . -name '*.fish' -not -path './.git/*')
TOML_FILES := $(shell find . -name '*.toml' -not -path './.git/*' -not -path './yazi/flavors/*')

# The only colors the configs may use. Upstream theme files ship the full
# extended palette, so they are excluded. Only hex literals are checked, the
# rgba() forms in waybar/style.css are not.
PALETTE := 282a36|44475a|6272a4|8be9fd|50fa7b|f1fa8c|ffb86c|ff79c6|bd93f9|ff5555|f8f8f2
PALETTE_EXCLUDES := ':!yazi/flavors' ':!alacritty/dracula.toml' ':!fish/themes'

# Colors
COLOR := \033[36m
NOCOLOR := \033[0m

.SILENT:
.PHONY: all build switch gitconfig-user check check-nix lint lint-fix \
	markdown-lint prettier typos shfmt shellcheck fish-lint lua-lint yaml-lint \
	toml-lint colors smoke updates-test test clean help

##@ Build targets:

all: switch ## Build and switch to the NixOS configuration (default).

build: ## Build the NixOS configuration without activating it.
	nix build .\#nixosConfigurations.$(HOST).config.system.build.toplevel

switch: ## Build and switch to the NixOS configuration.
	sudo nixos-rebuild switch --flake .\#$(HOST)

##@ Setup targets:

gitconfig-user: ## Generate the user-specific gitconfig (keeps other settings in the file).
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.name "$(GIT_USER)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.email "$(EMAIL)"
	$(GIT) config -f $(GITCONFIG_USER_PATH) user.signingKey "$(SIGNKEY)"
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
	$(NIX_SHELL) nixpkgs\#markdownlint-cli2 -c markdownlint-cli2 '**/*.md' '!yazi/flavors/**' '!result/**'

prettier: ## Check formatting with prettier.
	$(NIX_SHELL) nixpkgs\#prettier -c prettier --check .

typos: ## Check for typos.
	$(NIX_SHELL) nixpkgs\#typos -c typos

shfmt: ## Check shell script formatting.
	$(NIX_SHELL) nixpkgs\#shfmt -c shfmt -d .

shellcheck: ## Lint shell scripts, found by shebang.
	files=$$(grep -rlE '^#!.*[[:space:]/](bash|dash|ksh|sh)$$' \
		--binary-files=without-match --exclude-dir=.git --exclude-dir=result .); \
	$(NIX_SHELL) nixpkgs\#shellcheck -c shellcheck $$files

fish-lint: ## Check fish syntax and formatting.
	$(NIX_SHELL) nixpkgs\#fish -c bash -c \
		'for f in $(FISH_FILES); do fish --no-execute "$$f" || exit 1; done && fish_indent --check $(FISH_FILES)'

yaml-lint: ## Lint all YAML files.
	$(NIX_SHELL) nixpkgs\#yamllint -c yamllint --strict .

toml-lint: ## Check TOML formatting.
	$(NIX_SHELL) nixpkgs\#taplo -c taplo fmt --check $(TOML_FILES)

colors: ## Check that configs only use the Dracula palette.
	stray=$$({ \
		git grep -hoiE '#[0-9a-f]{6}([0-9a-f]{2})?\b' -- . $(PALETTE_EXCLUDES); \
		git grep -hoiE '^[a-z-]+=[0-9a-f]{8}$$' -- fuzzel/fuzzel.ini | cut -d= -f2; \
	} | tr 'A-F' 'a-f' | sed 's/^#//' | cut -c1-6 | sort -u \
		| { grep -vE '^($(PALETTE))$$' || true; }); \
	test -z "$$stray" || { \
		echo "Colors outside the Dracula palette:"; \
		for c in $$stray; do \
			git grep -inE "$$c" -- . $(PALETTE_EXCLUDES) | sed 's/^/  /'; \
		done; \
		exit 1; \
	}

smoke: ## Run the status bar scripts and check they emit valid JSON.
	$(NIX_SHELL) nixpkgs\#jq -c bash -c ' \
	fail=0; \
	for s in "waybar/cpu --once" "waybar/memory --once" "waybar/gpu --once" \
		"waybar/network --once" waybar/temps waybar/fans waybar/power waybar/dnd \
		waybar/failed-units; do \
		if out=$$(./$$s 2>&1) && printf "%s" "$$out" | jq -e . >/dev/null 2>&1; then \
			echo "  OK: $$s"; \
		else \
			echo "  FAIL: $$s"; \
			echo "$$out" | sed "s/^/    /"; \
			fail=1; \
		fi; \
	done; \
	exit $$fail'

# The pending updates logic is pure jq, so it is checked against fixtures here
# rather than in smoke, which would have to evaluate the whole configuration.
updates-test: ## Check the pending updates logic against the waybar/testdata fixtures.
	$(NIX_SHELL) nixpkgs\#jq -c bash -c ' \
	set -e; \
	d=waybar/testdata; \
	render() { jq -cn --argjson old "$$(cat $$d/updates-old.json)" \
		--argjson new "$$(cat $$1)" --arg icon ICON -f waybar/nix-updates.jq; }; \
	render $$d/updates-new.json | jq -e -f $$d/updates-assert.jq >/dev/null; \
	echo "  OK: upgrades"; \
	render $$d/updates-old.json | jq -e ".text | length == 0" >/dev/null; \
	echo "  OK: no upgrades"'

lua-lint: ## Check Lua formatting and lint.
	$(NIX_SHELL) nixpkgs\#stylua nixpkgs\#luajitPackages.luacheck -c bash -c \
		'stylua --check nvim/ && luacheck nvim/'

test: lint check-nix markdown-lint prettier typos shfmt shellcheck fish-lint lua-lint yaml-lint toml-lint colors updates-test ## Run all checks.

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
