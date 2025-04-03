
bootstrap:
	mkdir -p ~/.config/nix
	echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
	sudo launchctl kickstart -k system/org.nixos.nix-daemon
	cd ~/.config && git clone https://github.com/jalevin/dotfiles.nix.git nixpkgs && cd nixpkgs
	# Install nix
	curl -L https://nixos.org/nix/install | sh
	# Install nix-darwin using the Nix package manager
	nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer
	# Now we can rebuild and switch
	~/.nix-profile/bin/darwin-rebuild switch --flake ~/.config/nixpkgs
	~/.nix-profile/bin/home-manager switch -b backup

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
