DOTFILES_DIR=${HOME}/projects/dotfiles.nix

.PHONY: help
help: ## Show this help menu
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

## use determinate installer
xcode: ## Install Xcode command line tools
	sudo softwareupdate -i -a
	xcode-select --install

bootstrap: ## Bootstrap nix-darwin installation (removes homebrew, installs nix)
	# remove homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	# install nix via determinate, but don't user determinate and allow nix-darwin to manage nix
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
	# start the daemon
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
	# do the install
	nix run nix-darwin -- switch --flake ~/projects/dotfiles.nix

post-install: ## Configure iTerm2 preferences after installation
	# Specify the preferences directory
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${DOTFILES_DIR}/configs/iterm2"
	# Tell iTerm2 to use the custom preferences in the directory
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

nuke: ## Uninstall nix-darwin and nix completely
	# remove nix-darwin
	nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
	# remove nix
	/nix/nix-installer uninstall /nix/receipt.json

rebuild: ## Rebuild and switch to the new configuration
	darwin-rebuild switch --flake .
