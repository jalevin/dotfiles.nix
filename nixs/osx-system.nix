{ config, lib, pkgs, user, architecture, homebrew-core, homebrew-cask, homebrew-bundle, dagger-tap, ... }:
{
  # use the id from determinate installer
  ids.gids.nixbld = 350;
  users.users.${user}.home = "/Users/${user}";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = architecture;

  imports = [  ./osx-settings.nix ];

  ## PACKAGES
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs._1password-cli
    pkgs.ansible
    pkgs.awscli
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.direnv
    pkgs.gitFull
    pkgs.go
    pkgs.go-task
    pkgs.heroku
    pkgs.htop
    pkgs.jq
    pkgs.mise
    pkgs.neovim
    pkgs.nix-direnv
    pkgs.nmap
    pkgs.ripgrep
    pkgs.tflint
    pkgs.tldr
    pkgs.tree
    pkgs.watch
    pkgs.wget

    # ruby / CSFP
    #pkgs.libpq
    pkgs.openssl
    pkgs.readline
  ];


  ## BREW
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Uninstalls all formulae not listed here
    };

    brews = [
      "dagger"
      "nodenv"
      "pyenv"
      "ruby-build"
    ];

    casks = [
      # GUI apps via Homebrew
      "1password"
      "alfred"
      "brave-browser"
      "cyberduck"
      "discord"
      "docker"
      "google-chrome"
      "handbrake"
      "iterm2"
      "orbstack"
      #"jump" // This requires a license. Use version stored in icloud or synology
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "tableplus"
      "tailscale"
      "tuple"
      "visual-studio-code"
      "whatsapp"
      "xbar"
    ];
  };

}
