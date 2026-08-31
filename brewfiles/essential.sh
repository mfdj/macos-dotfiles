#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring essential packages

# NOTE: this is a subset of brewfiles/core used by the installer script
brew_ensure fd # for telescope.nvim
brew_ensure ripgrep
brew_ensure neovim

cask_ensure font-jetbrains-mono
cask_ensure font-monaspace-frozen
cask_ensure font-monaspice-nerd-font
cask_ensure rectangle-pro

echo # visual line break


