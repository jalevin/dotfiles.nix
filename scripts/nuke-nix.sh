#!/bin/bash
# Script to remove Nix completely from a macOS system

echo "WARNING: This will completely remove Nix, nix-darwin, and all related configurations from your system."
echo "This action cannot be undone."
echo -n "Are you sure you want to continue? (y/N): "
read confirm

if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo "Removing Nix from your system..."

    # 1. Revert shell configs
    echo "Revert shell configs"
    sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
    sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
    sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc
    
    # 2. Stop the nix-daemon
    echo "Stopping nix daemon"
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
    sudo rm -f /Library/LaunchDaemons/org.nixos.darwin-store.plist
    
    # 3. Remove nixbld group and users
    echo "Removing nix groups and users"
    sudo dscl . -delete /Groups/nixbld
    for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done

    # 4. Remove mount in fstab
    echo "Remove volume from fstab"
    sudo vifs

    # 5. Remove synthetic.conf (we don't use for anything else)
    echo "Removing virtual mount"
    sudo rm -f /etc/synthetic.conf

    # 6. Remove files nix added to system
    echo "Removing nix files on disk"
    sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

    # 7. Remove nix volume
    echo "Removing nix volume"
    sudo diskutil apfs deleteVolume /nix
    
    # 8. Removing bootstrap config
    rm -rf ~/.config/nixpkgs
    rm -rf ~/.config/nix

    echo "Nix has been removed from your system. You may need to restart your terminal or reboot to complete the process."
else
    echo "Operation canceled."
fi
