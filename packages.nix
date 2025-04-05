{ config, pkgs, pkgs-stable, ... }:
let
in
{
  home.packages = [
    pkgs.ansible
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
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

    #pkgs.ruby-build
    #pkgs.terraform
  ];

  # Use this to get gitk
  programs.git = {
    enable = true;
    package = pkgs.gitFull;  # Use the full-featured Git
  };
}
