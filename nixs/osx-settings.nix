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
  system.activationScripts.userDefaults.text = ''
    # Run user-specific defaults as the primary user
    sudo -u ${config.system.primaryUser} bash <<'EOF'
    # Create Screenshots directory
    mkdir -p "$HOME/Downloads/Screenshots"

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Set Time Machine to not prompt for new disks
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

    # Disable smart quotes in Messages
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

    # disable spotlight hotkey
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:64" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist


    # Add hotkey Cmd+Shift+D to toggle notifications

    # First, establish the key combination parameters
    # 100 = d
    # 1048576 = Command key
    # 131072 = Shift key
    # Parameters: enabled, type, value, parameters: (key code, modifiers)

    # Remove existing shortcut if it exists
    /usr/libexec/PlistBuddy -c "Delete :dnd:menuBarEnabled" ~/Library/Preferences/com.apple.controlcenter.plist 2>/dev/null || true

    # Enable Do Not Disturb in menu bar so the shortcut can work
    /usr/libexec/PlistBuddy -c "Add :dnd:menuBarEnabled bool true" ~/Library/Preferences/com.apple.controlcenter.plist

    # Define a custom keyboard shortcut for Do Not Disturb
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 175 "
      <dict>
        <key>enabled</key><true/>
        <key>value</key><dict>
          <key>type</key><integer>0</integer>
          <key>parameters</key>
          <array>
            <integer>100</integer>
            <integer>1179648</integer>
          </array>
        </dict>
      </dict>
  "
EOF
  '';
  
  # Show the /Volumes folder (requires sudo in the original script)
  system.activationScripts.extraActivation.text = ''
    /bin/chmod u+x /Volumes
    /usr/bin/chflags nohidden /Volumes
  '';

  security.pam.services.sudo_local.touchIdAuth = true;
}
