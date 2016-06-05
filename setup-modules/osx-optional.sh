#!/usr/bin/env bash

require 'functions/plist-helpers'

# TODO:
# Finder > Preferences >
#   General > New Finder windows show > user folder (not all my files)
#   Sidebar > check User; unchceck All My Files, iCloud Drive, AirDrop, Shared, Tags, etc.
#   Advanced > When performing a search > Search the Current Folder

echo 'Ensuring dark-mode enabled (toggle: control + option + command + t)'
dark_mode=$(defaults read /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey 2> /dev/null)
[[ $dark_mode != 1 ]] \
   && sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true


echo 'Ensuring gamed is unloaded'
[[ -f /System/Library/LaunchAgents/com.apple.gamed.plist ]] \
   && launchctl unload /System/Library/LaunchAgents/com.apple.gamed.plist 2> /dev/null
