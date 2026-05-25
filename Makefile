.PHONY: help test update-readme update-readme-dry-run validate-manifest scan-outdated update-package

.DEFAULT_GOAL := help

help:
	@echo "Homebrew tap automation targets:"
	@echo "  make test                         Run dry-run README update and manifest validation"
	@echo "  make update-readme                Update README.md application table"
	@echo "  make update-readme-dry-run        Preview README.md application table update"
	@echo "  make validate-manifest            Validate packages/manifest.yml"
	@echo "  make scan-outdated                Scan manifest packages for newer releases"
	@echo "  make update-package PACKAGE=name  Update a package to latest release"
	@echo "  make update-package PACKAGE=name VERSION=1.2.3"

test:
	ruby scripts/update-readme.rb --dry-run
	ruby scripts/validate-manifest.rb

update-readme:
	ruby scripts/update-readme.rb

update-readme-dry-run:
	ruby scripts/update-readme.rb --dry-run

validate-manifest:
	ruby scripts/validate-manifest.rb

scan-outdated:
	ruby scripts/scan-outdated.rb

update-package:
	@test -n "$(PACKAGE)" || { echo "PACKAGE is required. Usage: make update-package PACKAGE=mdctl [VERSION=0.1.2]" >&2; exit 1; }
	ruby scripts/update-package.rb --package "$(PACKAGE)" $(if $(VERSION),--version "$(VERSION)",)
