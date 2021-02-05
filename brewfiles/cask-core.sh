#!/usr/bin/env bash

require 'functions/brew-helpers'

cask_ensure  app-tamer
cask_ensure  flux
cask_ensure  kaleidoscope
cask_ensure  knox
cask_ensure  macdown
cask_ensure  slack
cask_ensure  sourcetree
cask_ensure  spectacle
cask_ensure  sequel-pro
cask_ensure  visual-studio-code

# prefer system Chrome if it's installed (fixes issues with 1password extension)
[[ -d /Applications/Google\ Chrome.app ]] || cask_ensure google-chrome
