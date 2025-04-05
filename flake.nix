{
  description = "Home Manager and Darwin configuration";
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
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self,
    nixpkgs, 
    nixpkgs-stable,
    nix-index-database,
    home-manager,
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }:
  let
    username = "jeff";
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # For use with home-manager switch --flake .
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ 
        ./home.nix 
        nix-index-database.hmModules.nix-index
      ];
      extraSpecialArgs = {
        pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      };
    };

    # For use with darwin-rebuild switch --flake .
    darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { 
        inherit pkgs; 
        inherit nix-homebrew homebrew-core homebrew-cask;
      };
      modules = [
        ./darwin-configuration.nix
        # Include home-manager as a darwin module
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home.nix;
          home-manager.extraSpecialArgs = {
            pkgs-stable = nixpkgs-stable.legacyPackages.${system};
          };
        }
        # Include homebrew module from nix-homebrew
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            user = "${username}";
            taps = {
              "homebrew/core" = homebrew-core;
              "homebrew/cask" = homebrew-cask;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
      ];
    };

    # Apps to make commands easier to access
    apps.${system}.default = {
      type = "app";
      program = "${nix-darwin.packages.${system}.darwin-rebuild}/bin/darwin-rebuild";
    };
  };
}
