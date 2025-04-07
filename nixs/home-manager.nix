{ config, pkgs, dotfilesRoot, ... }:
let
  # Adjust this path as needed based on your actual file structure
  configsRoot = "${dotfilesRoot}/configs";
in
{
  home.stateVersion = "24.05";
  home.username = "jeff";
  home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/jeff";
  programs.home-manager.enable = true;
  
  #config.allowUnfree = true;

  home.file = {
    ".sqliterc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/sqliterc";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/tmux.conf";
    ".gemrc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/gemrc";

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/nvim";
    ".config/1Password".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/1Password";
    ".config/op".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/op";
  };
  
  imports = [
    ./zsh.nix 
    ./direnv.nix
    ./git.nix 
  ];
}
