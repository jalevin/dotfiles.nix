bootstrap:
	# setup dirs & configs
	mkdir -p ~/.config/nix
	echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
	cd ~/.config && git clone https://github.com/jalevin/dotfiles.nix.git nixpkgs && cd nixpkgs
	# Install nix
	curl -L https://nixos.org/nix/install | sh
	# Start the daemon
	sudo launchctl kickstart -k system/org.nixos.nix-daemon
	cd ~/.config/nixpkgs && nix run . && home-manager switch  -b backup
	#echo "nix installed. open a new shell in this dir and run \"make finish-setup\""

#finish-setup:
	#cd ~/.config/nixpkgs && nix run .
#  # Install nix-darwin using the Nix package manager
#  nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
#  nix-channel --update
#  # Rebuild and switch
#  ~/.nix-profile/bin/darwin-rebuild switch --flake ~/.config/nixpkgs
#  ~/.nix-profile/bin/home-manager switch -b backup

update:
	cd ~/.config/nixpkgs && \
		~/.nix-profile/bin/darwin-rebuild switch --flake . && \
		~/.nix-profile/bin/home-manager switch -b backup

# A simpler target that just updates the system with the current config
quick-update:
	~/.nix-profile/bin/darwin-rebuild switch --flake ~/.config/nixpkgs
	~/.nix-profile/bin/home-manager switch -b backup

nuke:
	@./scripts/nuke-nix.sh
