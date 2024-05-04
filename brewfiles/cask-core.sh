#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring cask-core packages

cask_ensure  app-tamer
cask_ensure  flux
cask_ensure  kaleidoscope
cask_ensure  macdown
cask_ensure  sourcetree
cask_ensure  sequel-pro

# defer to pre-installed software
cask_ensure_unless_directory google-chrome  /Applications/Google\ Chrome.app # at one point installing outside of cask fixed an issue with 1password extension
cask_ensure_unless_directory slack          /Applications/Slack.app

echo # visual line break
