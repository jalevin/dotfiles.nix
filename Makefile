## use determinate installer
bootstrap:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
	  sh -s -- install --determinate
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer

nuke:
	nix-installer uninstall /path/to/receipt.json

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
