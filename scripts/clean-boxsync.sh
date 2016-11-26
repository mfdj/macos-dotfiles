#!/usr/bin/env bash

# https://community.box.com/t5/Box-Sync/How-Do-I-Install-or-Uninstall-Box-Sync-4-0/ta-p/85

sudo rm -rf \
   ~/Library/Logs/Box/Box\ Sync \
   ~/Library/Application\ Support/Box/Box\ Sync \
   /Library/PrivilegedHelperTools/com.box.sync.bootstrapper \
   /Library/PrivilegedHelperTools/com.box.sync.iconhelper
