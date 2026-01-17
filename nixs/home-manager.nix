{ config, pkgs, dotfilesRoot, inputs, ... }:
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

  home.packages = with pkgs; [ claude-code ];

  home.file = {
    ".sqliterc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/sqliterc";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/tmux.conf";
    ".gemrc".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/gemrc";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/nvim";

    #".config/1Password".source = "${configsRoot}/1Password";
    #".config/op".source = "${configsRoot}/op";

    ".config/1Password/ssh/agent.toml".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/1Password/ssh/agent.toml";
    ".config/op/plugins.json".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/op/plugins.json";
    ".config/op/aws.json".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/op/aws.json";
    ".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${configsRoot}/ghostty/config";
  };
  
  imports = [
    ./zsh.nix 
    ./direnv.nix
    ./git.nix 
  ];
}
