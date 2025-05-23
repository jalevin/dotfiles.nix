{
  description = "System flake configuration file";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    dagger-tap = {
      url = "github:dagger/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{ 
    self, 
    nix-darwin, 
    nixpkgs, 
    home-manager, 
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    dagger-tap,
    ...
    }:
    let
      user = "jeff";
      hostname = "Jeffreys-MacBook-Pro";
      architecture = "aarch64-darwin";
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro
      darwinConfigurations."${hostname}" =
        nix-darwin.lib.darwinSystem {
          system = architecture;
          modules = [

            {
              imports = [ ./nixs/osx-system.nix ];
              _module.args = { inherit user architecture homebrew-core homebrew-cask homebrew-bundle dagger-tap; };
            }

            home-manager.darwinModules.home-manager
            {
              # `home-manager` config
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                dotfilesRoot = self.outPath;
              };
              home-manager.users.${user} = import ./nixs/home-manager.nix;
            }

            nix-homebrew.darwinModules.nix-homebrew {
              nix-homebrew = {
                enable = true;
                autoMigrate = true;
                enableRosetta = true;
                user = user;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                  "dagger/tap" = dagger-tap;
                };
                mutableTaps = false;
              };
            }

          ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."${hostname}".pkgs;
    };
}
