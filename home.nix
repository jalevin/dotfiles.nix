{ config, pkgs, ... }: {
  home.username = "jeff";
  home.homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/jeff";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.file = {
    # demo vim config
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink ./vim_configuration;

    # rc files
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/zshrc";
    ".sqliterc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/sqliterc";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/tmux.conf";
    ".gemrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/gemrc";

    # directories
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/nvim";
    ".config/1Password".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/1Password";
    ".config/op".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/configs/op";
  };

  imports = [ ./git.nix ]; #./packages.nix ./vim.nix  ./rest.nix ];
}
