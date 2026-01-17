{ config, lib, pkgs, user, architecture, homebrew-core, homebrew-cask, homebrew-bundle, dagger-tap, beads-tap, ... }:
{
  # use the id from determinate installer
  ids.gids.nixbld = 350;
  users.users.${user}.home = "/Users/${user}";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "root" "jeff" ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = architecture;
  # Primary user for system defaults and homebrew
  system.primaryUser = user;

  imports = [  ./osx-settings.nix ];

  ## PACKAGES
  nixpkgs.config.allowUnfree = true;

  # Override mise to get latest version - use pre-built binary
  nixpkgs.overlays = [
    (final: prev: {
      mise = prev.stdenv.mkDerivation rec {
        pname = "mise";
        version = "2025.12.0";

        src = prev.fetchurl {
          url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-macos-arm64";
          sha256 = "sha256-3kPkNUU2Z4n6f5SRZsWfdhbwZNTnYgAyatTn+zP18ZU=";
        };

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/mise
          chmod +x $out/bin/mise
        '';

        meta = {
          mainProgram = "mise";
        };
      };
    })
  ];

  environment.systemPackages = [
    pkgs._1password-cli
    pkgs.ansible
    pkgs.awscli
    pkgs.bat
    pkgs.coreutils
    pkgs.curl
    pkgs.direnv
    pkgs.gitFull
    pkgs.go
    pkgs.go-task
    pkgs.heroku
    pkgs.htop
    pkgs.jq
    pkgs.libwebp
    pkgs.mise
    pkgs.neovim
    pkgs.nix-direnv
    pkgs.nmap
    pkgs.ripgrep
    pkgs.tflint
    pkgs.tldr
    pkgs.tree
    pkgs.watch
    pkgs.wget

    # ruby / CSFP
    #pkgs.libpq
    pkgs.openssl
    pkgs.readline
  ];


  ## BREW
  homebrew = {
    enable = true;
    global.autoUpdate = false;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Uninstalls all formulae not listed here
    };

    taps = [
    ];

    brews = [
      "bd"
      "dagger"
      "nodenv"
      "pyenv"
      "ruby-build"
    ];

    casks = [
      # GUI apps via Homebrew
      "1password"
      "alfred"
      "brave-browser"
      "cyberduck"
      "discord"
      "docker-desktop"
      "google-chrome"
      "handbrake-app"
      "iterm2"
      "orbstack"
      #"jump" // This requires a license. Use version stored in icloud or synology
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "tableplus"
      "tailscale-app"
      "tuple"
      "visual-studio-code"
      "whatsapp"
      "xbar"
    ];
  };

}
