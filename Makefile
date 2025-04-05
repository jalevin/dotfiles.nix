## use determinate installer
xcode:
	sudo softwareupdate -i -a
	xcode-select --install

bootstrap: #xcode
	# remove homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
	# install nix via determinate, but don't user determinate and allow nix-darwin to manage nix
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
	# start the daemon
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
	# do the install
	nix run nix-darwin -- switch --flake ~/projects/dotfiles.nix

nuke:
	# remove nix-darwin
	nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-uninstaller
	# remove nix
	/nix/nix-installer uninstall /nix/receipt.json

rebuild:
	darwin-rebuild switch --flake .
