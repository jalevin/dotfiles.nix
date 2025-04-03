{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    let
      configuration = { pkgs, ... }: {
        ## SYSTEM ##
        services.nix-daemon.enable = true;
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";
        system.configurationRevision = self.rev or self.dirtyRev or null;
        # Used for backwards compatibility. please read the changelog 
        # before changing: `darwin-rebuild changelog`.
        system.stateVersion = 4;
        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
        security.pam.enableSudoTouchIdAuth = true;
        # Create /etc/zshrc that loads the nix-darwin environment. 
        programs.zsh.enable = true;
        environment.systemPackages = [ pkgs.neofetch ];
        ## END SYSTEM ##

        # Declare the user that will be running `nix-darwin`.
        users.users.jeff = {
          name = "jeff";
          home = "/Users/jeff";
        };

        #homebrew = {
        #  enable = true;
        #  # onActivation.cleanup = "uninstall";
        #  taps = [ ];
        #  brews = [ "cowsay" ];
        #  casks = [ ];
        #};
      };

      homeconfig = { pkgs, ... }: {
        # this is internal compatibility configuration for home-manager, 
        # don't change this!
        home.stateVersion = "23.05";
        # Let home-manager install and manage itself.
        programs.home-manager.enable = true;
        ## symlinks
        home.file.".vimrc".source = ./vim_configuration;

        home.packages = with pkgs; [ ];

        home.sessionVariables = {
          EDITOR = "vim";
        };

        programs.zsh = {
          enable = true;
          shellAliases = {
            switch = "darwin-rebuild switch --flake ~/.config/nix";
          };
        };

        # Git configuration commented out for now
      };
    in
    {
      darwinConfigurations."Jeffreys-MacBook-Pro.local" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.jeff = homeconfig;
          }
        ];
      };
      
      # Use newer home-manager app approach instead of defaultPackage
      apps = {
        aarch64-darwin.default = {
          type = "app";
          program = "${home-manager.packages.aarch64-darwin.home-manager}/bin/home-manager";
        };
        x86_64-darwin.default = {
          type = "app";
          program = "${home-manager.packages.x86_64-darwin.home-manager}/bin/home-manager";
        };
      };
    };
}
