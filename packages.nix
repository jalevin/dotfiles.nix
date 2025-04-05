{ pkgs, pkgs-stable, ... }:
  home.packages = [
    pkgs.ansible
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.git-gui
    pkgs.jsonnet
    pkgs.jsonnet-bundler
    pkgs.neovim
    pkgs.nmap
    pkgs.htop
    pkgs.ruby-build
    pkgs.terraform
    pkgs.tldr
    pkgs.jq
    pkgs.nodejs
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.wget
  ];
