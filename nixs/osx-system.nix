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
    pkgs.awscli
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.gitFull
    pkgs.go
    pkgs.go-task
    pkgs.heroku
    pkgs.htop
    pkgs.jq
    pkgs.neovim
    pkgs.nmap
    pkgs.ripgrep
    pkgs.terraform
    pkgs.tflint
    pkgs.tldr
    pkgs.tree
    pkgs.watch
    pkgs.wget
  ];

  ## BREW
  homebrew = {
    enable = true;
    global.autoUpdate = false;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Uninstalls all formulae not listed here
    };


    taps = [
      "dagger/tap"
    ]

    brews = [
      "dagger/tap/dagger"
      "nodenv"
      "pyenv"
      "rbenv"
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
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "tableplus"
      "tuple"
      "visual-studio-code"
      "whatsapp"
      "xbar"
    ];
  };
}
