#!/usr/bin/env bash

## Checking launchctl
# https://apple.stackexchange.com/questions/37188/stopping-launchagents-and-daemons

echo -n 'Files in LaunchAgents & LaunchDaemons folders: '
find ~/Library/LaunchAgents \
     /Library/LaunchAgents \
     /Library/LaunchDaemons \
     /System/Library/LaunchAgents \
     /System/Library/LaunchDaemons \
     -type f | wc -l

echo -n '.plist files in LaunchAgents & LaunchDaemons folders: '
find ~/Library/LaunchAgents \
     /Library/LaunchAgents \
     /Library/LaunchDaemons \
     /System/Library/LaunchAgents \
     /System/Library/LaunchDaemons \
     -type f -name '*.plist' | wc -l

echo 'grepping for procinfo in in LaunchAgents & LaunchDaemons'
find ~/Library/LaunchAgents \
     /Library/LaunchAgents \
     /Library/LaunchDaemons \
     /System/Library/LaunchAgents \
     /System/Library/LaunchDaemons \
     -type f -exec grep procinfo {} \;

# also:
#   sudo launchctl list | grep …
#   sudo launchctl dumpstate > launchctl-dumpstate

## Malware?
# https://gbhackers.com/macos-signature-validation-flaw/
