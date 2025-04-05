{ config, pkgs, nix-homebrew, ... }:

{
  # System-level configuration
  # Set your system preferences here
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        ShowPathbar = true;
      };
    };
    # Enable keyboard mapping; needed for using Karabiner
    keyboard.enableKeyMapping = true;
  };

  # Configure Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; // Uninstalls all formulae not listed here
    };
    brews = [
      # CLI tools via Homebrew
    ];
    casks = [
      # GUI apps via Homebrew
      "whatsapp"
    ];
  };

  # Add system-wide packages 
  environment.systemPackages = with pkgs; [
    # System packages here
  ];

  # Nix configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # Used for backwards compatibility
  services.nix-daemon.enable = true;
}
