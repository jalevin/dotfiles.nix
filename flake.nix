{
  description = "Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nix-index-database, ... }:
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
      # Updated to use the new structure instead of defaultPackage
      packages = {
        #x86_64-darwin.default = self.homeConfigurations."Jeffreys-MacBook-Pro".activationPackage;
        aarch64-darwin.default = self.homeConfigurations."Jeffreys-MacBook-Pro.local".activationPackage;
        #aarch64-linux.default = self.homeConfigurations."Jeffreys-MacBook-Pro".activationPackage;
      };
      
      # Define the apps to provide the home-manager command
      apps = {
        x86_64-darwin.default = {
          type = "app";
          program = "${home-manager.packages.x86_64-darwin.home-manager}/bin/home-manager";
        };
        aarch64-darwin.default = {
          type = "app";
          program = "${home-manager.packages.aarch64-darwin.home-manager}/bin/home-manager";
        };
        aarch64-linux.default = {
          type = "app";
          program = "${home-manager.packages.aarch64-linux.home-manager}/bin/home-manager";
        };
      };
      
      homeConfigurations = {
        "Jeffreys-MacBook-Pro" = withArch "aarch64-darwin";
      };
    };
}
