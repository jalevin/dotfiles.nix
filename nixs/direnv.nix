{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    
    # Enhanced direnv configuration
    stdlib = ''
      # Custom direnv functions can go here
      
      # Helper to load .env files if they exist
      load_env() {
        local env_file="$1"
        if [ -f "$env_file" ]; then
          watch_file "$env_file"
          dotenv "$env_file"
        fi
      }
      
      # Helper to use a specific flake from the current directory
      use_flake_dev() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
      }
    '';
  };
}
