bootstrap:
	# setup dirs & configs
	mkdir -p ~/.config/nix
	echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
	cd ~/.config && git clone https://github.com/jalevin/dotfiles.nix.git nixpkgs && cd nixpkgs
	# Install nix
	curl -L https://nixos.org/nix/install | sh
	# Start the daemon
	sudo launchctl kickstart -k system/org.nixos.nix-daemon
	cd ~/.config/nixpkgs && nix run . -- switch --flake .

update:
	nix run . -- switch --flake .

nuke:
	@./scripts/nuke-nix.sh
