{ config, pkgs, nix-homebrew, ... }:
{
  # Import the split files
  imports = [
    ./osx-settings.nix
    ./brew.nix
  ];

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
