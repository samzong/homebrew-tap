BOLD  := \033[1m
CYAN  := \033[36m
GREEN := \033[32m
RESET := \033[0m

.DEFAULT_GOAL := help

# ── Quality ──────────────────────────────────────────────────────────────────

.PHONY: test validate-manifest

test: ## Dry-run the README update and validate the manifest
	ruby scripts/update-readme.rb --dry-run
	ruby scripts/validate-manifest.rb

validate-manifest: ## Validate packages/manifest.yml
	ruby scripts/validate-manifest.rb

# ── README ───────────────────────────────────────────────────────────────────

.PHONY: update-readme update-readme-dry-run

update-readme: ## Regenerate the README application table
	ruby scripts/update-readme.rb

update-readme-dry-run: ## Preview the README application table update
	ruby scripts/update-readme.rb --dry-run

# ── Packages ─────────────────────────────────────────────────────────────────

.PHONY: scan-outdated update-package

scan-outdated: ## Scan manifest packages for newer releases
	ruby scripts/scan-outdated.rb

update-package: ## Update a package (PACKAGE=name, optional VERSION=1.2.3)
	@test -n "$(PACKAGE)" || { echo "PACKAGE is required. Usage: make update-package PACKAGE=mdctl [VERSION=0.1.2]" >&2; exit 1; }
	ruby scripts/update-package.rb --package "$(PACKAGE)" $(if $(VERSION),--version "$(VERSION)",)

# ── Help ─────────────────────────────────────────────────────────────────────

.PHONY: help

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*## "; printf "\n$(BOLD)Homebrew Tap$(RESET) — Homebrew formulae and casks by samzong\n"} \
		/^# ── / {n = $$0; gsub(/(^# ── | (─)+$$)/, "", n); printf "\n$(BOLD)%s$(RESET)\n", n} \
		/^[a-zA-Z0-9_-]+:.*## / {printf "  $(CYAN)make %-22s$(RESET) %s\n", $$1, $$2} \
		END {printf "\n"}' $(MAKEFILE_LIST)
