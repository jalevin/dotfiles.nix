{ config, pkgs, ... }:
{
  # Configure Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Uninstalls all formulae not listed here
    };
    brews = [
      # CLI tools via Homebrew
    ];
    casks = [
      # GUI apps via Homebrew
      "whatsapp"
    ];
  };
}
