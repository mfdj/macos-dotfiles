#!/usr/bin/env bash

require 'functions/brew-helpers'

cask_ensure  app-tamer
cask_ensure  flux
cask_ensure  kaleidoscope
cask_ensure  knox
cask_ensure  macdown
cask_ensure  sourcetree
cask_ensure  spectacle
cask_ensure  sequel-pro
cask_ensure  visual-studio-code

# defer to pre-installed software
cask_ensure_unless_directory google-chrome  /Applications/Google\ Chrome.app # at one point installing outside of cask fixed an issue with 1password extension
cask_ensure_unless_directory slack          /Applications/Slack.app
