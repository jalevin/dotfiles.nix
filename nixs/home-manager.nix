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
    # rc files
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/zshrc";
    ".sqliterc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/sqliterc";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/tmux.conf";
    ".gemrc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/gemrc";
    # directories
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/nvim";
    ".config/1Password".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/1Password";
    ".config/op".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/op";
  };
  
  imports = [ ./git.nix ]; # ./vim.nix 
}
