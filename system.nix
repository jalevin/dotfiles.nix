{ config, lib, pkgs, user, architecture, ... }:
{
  # use the id from determinate installer
  ids.gids.nixbld = 350;

  users.users.${user}.home = "/Users/${user}";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = architecture;

  imports = [ ./osx-settings.nix ];

  ## PACKAGES
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #environment.systemPackages = with pkgs; [
  #  neovim
  #  ripgrep
  #  curl
  #  wget
  #];
  environment.systemPackages = [
    pkgs.ansible
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.gitFull
    pkgs.jsonnet
    pkgs.jsonnet-bundler
    pkgs.neovim
    pkgs.nmap
    pkgs.htop
    pkgs.tldr
    pkgs.jq
    pkgs.nodejs
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.wget
  ]

  ## BREW
  homebrew = {
    enable = true;
    global.autoUpdate = false;

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
