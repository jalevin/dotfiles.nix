{ config, pkgs, ... }:
{
  # System-level configuration
  # Set your system preferences here
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
  };

  # Screenshot settings
  system.screencapture = {
    # Save screenshots to Downloads/Screenshots folder
    location = "~/Downloads/Screenshots";
  };

  # Screen saver settings
  system.screensaver = {
    # Require password immediately after sleep or screen saver begins
    askForPassword = 1;
    askForPasswordDelay = 0;
  };
  
  # Other preferences 
  system.desktopservices = {
    # Avoid creating .DS_Store files on network or USB volumes
    DSDontWriteNetworkStores = true;
    DSDontWriteUSBStores = true;
  };
  
  # Time Machine settings
  system.TimeMachine = {
    # Prevent Time Machine from prompting to use new hard drives as backup volume
    DoNotOfferNewDisksForBackup = true;
  };

  # Messages app settings
  system.defaults.messageshelper.MessageController = {
    # Disable smart quotes as it's annoying for messages that contain code
    SOInputLineSettings = {
      automaticQuoteSubstitutionEnabled = false;
    };
  };
  
  # Create Screenshots directory
  system.activationScripts.extraUserActivation.text = ''
    mkdir -p "$HOME/Downloads/Screenshots"
  '';
  
  # Show the /Volumes folder (requires sudo in the original script)
  system.activationScripts.extraActivation.text = ''
    /bin/chmod u+x /Volumes
    /usr/bin/chflags nohidden /Volumes
  '';
}
