#!/usr/bin/env bash

main() {
    configure_plist_apps # Configure all apps whose configurations are plists
    configure_iterm2
    configure_system
    configure_dock
    configure_finder
}

function configure_plist_apps() {
    quit "The Unarchiver"
    import_plist "cx.c3.theunarchiver" "The_Unarchiver.plist"
}

function configure_iterm2() {
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string ~/.local/share/dotfiles/iTerm2
    # Don’t display the annoying prompt when quitting iTerm
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false
}

function configure_system() {
    LOGIN_HOOK_PATH=~/.local/share/dotfiles/macOS/login_hook_script.sh
    LOGOUT_HOOK_PATH=~/.local/share/dotfiles/macOS/logout_hook_script.sh

    # Disable Gatekeeper for getting rid of unknown developers error
    sudo spctl --master-disable
    # Set computer name
    sudo scutil --set ComputerName "cowboy"
    sudo scutil --set LocalHostName "cowboy"
    sudo scutil --set HostName "cowboy"
    #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "cowboy"
    git config --global core.excludesfile ~/.gitignore
    # Store Identities in the KeyChain
    sudo ssh-add -K
    # Disable natural scrolling
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
    # Disable macOS startup chime sound
    sudo defaults write com.apple.loginwindow LoginHook $LOGIN_HOOK_PATH
    sudo defaults write com.apple.loginwindow LogoutHook $LOGOUT_HOOK_PATH
    # Enable tap to click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    # Configure keyboard repeat https://apple.stackexchange.com/a/83923/200178
    defaults write -g InitialKeyRepeat -int 15
    defaults write -g KeyRepeat -int 2
    # Disable "Correct spelling automatically"
    defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
    # Enable full keyboard access for all controls which enables Tab selection in modal dialogs
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    # Restart automatically if the computer freezes
    sudo systemsetup -setrestartfreeze on

    ###############################################################################
    # SSD-specific tweaks                                                         #
    ###############################################################################

    # Disable hibernation (speeds up entering sleep mode)
    sudo pmset -a hibernatemode 0

}

function configure_dock() {
    quit "Dock"
    # Don’t show recent applications in Dock
    defaults write com.apple.dock show-recents -bool false
    # Set the icon size of Dock items to 36 pixels
    defaults write com.apple.dock tilesize -int 36
    # Remove all (default) app icons from the Dock
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock recent-apps -array
    # Show only open applications in the Dock
    defaults write com.apple.dock static-only -bool true
    # Don’t animate opening applications from the Dock
    defaults write com.apple.dock launchanim -bool false
    # Disable Dashboard
    defaults write com.apple.dashboard mcx-disabled -bool true
    # Don’t show Dashboard as a Space
    defaults write com.apple.dock dashboard-in-overlay -bool true
    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true
    # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-delay -float 0
    # Disable the Launchpad gesture (pinch with thumb and three fingers)
    defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

        # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center

    # Top left screen corner → Mission Control
    defaults write com.apple.dock wvous-tl-corner -int 2
    defaults write com.apple.dock wvous-tl-modifier -int 0

    # Top right screen corner → Nofication Center
    defaults write com.apple.dock wvous-tr-corner -int 12
    defaults write com.apple.dock wvous-tr-modifier -int 0

    # Bottom right screen corner → Desktop
    defaults write com.apple.dock wvous-br-corner -int 4
    defaults write com.apple.dock wvous-br-modifier -int 0

    # Bottom left screen corner → Desktop
    defaults write com.apple.dock wvous-bl-corner -int 4
    defaults write com.apple.dock wvous-bl-modifier -int 0 
    open "Dock"
}

function configure_finder() {
    # Save screenshots to Downloads folder
    defaults write com.apple.screencapture location -string "${HOME}/Downloads"
    # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    # allow quitting via ⌘ + q; doing so will also hide desktop icons
    defaults write com.apple.finder QuitMenuItem -bool true
    # disable window animations and Get Info animations
    defaults write com.apple.finder DisableAllAnimations -bool true
    # Set Downloads as the default location for new Finder windows
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string \
        "file://${HOME}/Downloads/"
    # disable status bar
    defaults write com.apple.finder ShowStatusBar -bool false
    # disable path bar
    defaults write com.apple.finder ShowPathbar -bool false
    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # Disable disk image verification
    defaults write com.apple.frameworks.diskimages \
        skip-verify -bool true
    defaults write com.apple.frameworks.diskimages \
        skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages \
        skip-verify-remote -bool true
    # Use list view in all Finder windows by default
    # Four-letter codes for view modes: icnv, clmv, Flwv, Nlsv
    defaults write com.apple.finder FXPreferredViewStyle -string clmv
    # Disable the warning before emptying the Trash
    defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Show the ~/Library folder
    chflags nohidden ~/Library

    # Show the /Volumes folder
    sudo chflags nohidden /Volumes

    # Remove Dropbox’s green checkmark icons in Finder
    #file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
    #[ -e "${file}" ] && mv -f "${file}" "${file}.bak"
}

function quit() {
    app=$1
    killall "$app" > /dev/null 2>&1
}

function open() {
    app=$1
    osascript << EOM
tell application "$app" to activate
tell application "System Events"
set frontmost of process "iTerm2" to true
end tell
EOM
}

function import_plist() {
    domain=$1
    filename=$2
    defaults delete "$domain" &> /dev/null
    defaults import "$domain" "$filename"
}

main "$@"
