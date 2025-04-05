{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # not sure what this does
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-stable, nix-darwin, home-manager, nix-index-database, ... }:
    let
      withArch = arch:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          modules = [ ./home.nix nix-index-database.hmModules.nix-index ];
          extraSpecialArgs = {
            pkgs-stable = nixpkgs-stable.legacyPackages.${arch};
          };
        };
    in {
      # Define the apps to provide the home-manager command
      apps = {
        aarch64-darwin.default = {
          type = "app";
          program = "${home-manager.packages.aarch64-darwin.home-manager}/bin/home-manager";
        };
        #x86_64-darwin.default = {
        #  type = "app";
        #  program = "${home-manager.packages.x86_64-darwin.home-manager}/bin/home-manager";
        #};
        #aarch64-linux.default = {
        #  type = "app";
        #  program = "${home-manager.packages.aarch64-linux.home-manager}/bin/home-manager";
      };

      # Home configurations using username as the main identifier
      homeConfigurations = {
        # Default configuration by username
        "jeff" = withArch "aarch64-darwin";
        
        # You can add machine-specific configurations if needed
        # "jeff@work-laptop" = withArch "aarch64-darwin";
        # "jeff@personal-desktop" = withArch "aarch64-linux";
      };
    };
}
