{ config, lib, pkgs, user, architecture, ... }:
{
  # use the id from determinate installer
  ids.gids.nixbld = 350;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #vim
    #curl
    #gitAndTools.gitFull
    #mg
    #mosh
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = false;

    #casks = [ "kitty" ];
  };

  users.users.${user}.home = "/Users/${user}";

  #nix.enable = false;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = architecture;
}
