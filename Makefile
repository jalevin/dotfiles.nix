## use determinate installer
xcode:
	sudo softwareupdate -i -a
	xcode-select --install

bootstrap: #xcode
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	nix run nix-darwin -- switch --flake ~/.config/nix-darwin

nuke:
	/nix/nix-installer uninstall /nix/receipt.json

## use manual installer
manual-bootstrap:
	# setup dirs & configs
	mkdir -p ~/.config/nix
	echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
	cd ~/.config && git clone https://github.com/jalevin/dotfiles.nix.git nixpkgs && cd nixpkgs
	# Install nix
	# curl -L https://nixos.org/nix/install | sh
	# Start the daemon
	sudo launchctl kickstart -k system/org.nixos.nix-daemon
	cd ~/.config/nixpkgs && nix run . -- switch --flake .
manual-nuke:
	@./scripts/nuke-nix.sh

## rebuild
rebuild:
	nix run . switch
	#darwin-rebuild switch --flake .

rebuild-home:
	home-manager switch --flake .
