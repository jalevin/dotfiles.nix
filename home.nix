{ config, pkgs, ... }:
let
  # Get the directory containing the current file
  currentDir = builtins.dirOf __curPos.file;
  
  # Define dotfilesRoot relative to the current Nix file
  # Adjust this path as needed based on your actual file structure
  dotfilesRoot = "${currentDir}/configs";
in
{
  home.username = "jeff";
  home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/jeff";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  
  #config.allowUnfree = true;

  home.file = {
    # rc files
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/zshrc";
    ".sqliterc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/sqliterc";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/tmux.conf";
    ".gemrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/gemrc";
    # directories
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/nvim";
    ".config/1Password".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/1Password";
    ".config/op".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesRoot}/op";
  };
  
  imports = [ ./packages.nix ./brew.nix ./git.nix ]; # ./vim.nix  ./rest.nix ];
}
