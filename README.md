# Dotfiles.nix
modeled from:
    https://github.com/Arkham/dotfiles.nix

Clone this repo into ~/projects/dotfiles.nix

## How to use

1. Update
   ```bash
   make xcode
   ```
1. Bootstrap nix and nix-darwin
   ```bash
   make bootstrap
   ```
1. Rebuild as you make changes
   ```bash
   make rebuild
   ```
1. Uninstall if necessary
   ```bash
   make nuke
   ```

## TODO
 - [ ] configure direnv
 - [ ] rewrite zshrc using nix
