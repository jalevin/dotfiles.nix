{ pkgs, ... }: {
  home.username = "jeff";
  home.homeDirectory =
    "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/jeff";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.file.".vimrc".source = ./vim_configuration;




  #imports = [ ./packages.nix ./vim.nix ./git.nix ./rest.nix ];
}
