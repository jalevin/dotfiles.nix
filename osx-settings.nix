{ config, pkgs, ... }:
{
  # System-level configuration
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      # keyboard
      InitialKeyRepeat = 15;
      KeyRepeat = 5;
    };
    dock = {
      autohide = true;
      orientation = "left";
      tilesize = 36;
    };
    finder = {
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
      # When performing a search, search the current folder by default
      FXDefaultSearchScope = "SCcf";
      # Don't warn when changing file extensions
      FXEnableExtensionChangeWarning = false;
      # Use list view in all Finder windows by default
      FXPreferredViewStyle = "Nlsv";
    };
    # Screenshot settings
    screencapture = {
      # Save screenshots to Downloads/Screenshots folder
      location = "~/Downloads/Screenshots";
    };
    # Screen saver settings
    screensaver = {
      # Require password immediately after sleep or screen saver begins
      askForPassword = true;
      askForPasswordDelay = 0;
    };
  };
  
  # Create Screenshots directory and set other preferences via activation scripts
  system.activationScripts.extraUserActivation.text = ''
    # Create Screenshots directory
    mkdir -p "$HOME/Downloads/Screenshots"
    
    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    
    # Set Time Machine to not prompt for new disks
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
    
    # Disable smart quotes in Messages
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
  '';
  
  # Show the /Volumes folder (requires sudo in the original script)
  system.activationScripts.extraActivation.text = ''
    /bin/chmod u+x /Volumes
    /usr/bin/chflags nohidden /Volumes
  '';
}
