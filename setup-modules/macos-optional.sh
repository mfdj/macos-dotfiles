#!/usr/bin/env bash

require functions/plist-helpers

# TODO:
# Finder > Preferences >
#   General > New Finder windows show > user folder (not all my files)
#   Sidebar > check User; unchceck All My Files, iCloud Drive, AirDrop, Shared, Tags, etc.
#   Advanced > When performing a search > Search the Current Folder

echo 'Ensuring dark-mode enabled (toggle: control + option + command + t)'
# TODO: update for Sierra - option is now in system-prefs https://support.apple.com/kb/PH25158?locale=en_US&viewlocale=en_US
dark_mode=$(defaults read /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey 2> /dev/null)
if [[ $dark_mode != 1 ]]; then
   sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
fi

echo Ensuring gamed is unloaded
if [[ -f /System/Library/LaunchAgents/com.apple.gamed.plist ]]; then
   launchctl unload /System/Library/LaunchAgents/com.apple.gamed.plist 2> /dev/null
fi
