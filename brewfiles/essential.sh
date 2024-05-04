#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring essential packages

# NOTE: this is a subset of brewfiles/core used by the installer script
brew_ensure ripgrep
cask_ensure rectangle
cask_ensure visual-studio-code

echo # visual line break
