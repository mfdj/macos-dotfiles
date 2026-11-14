#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring cask-optional packages

cask_ensure  charles
cask_ensure  firefox
cask_ensure  kap
cask_ensure  licecap
cask_ensure  murus
cask_ensure  rubymine
cask_ensure  processing
cask_ensure  screenflow
cask_ensure  vlc

cask_ensure_unless_directory visual-studio-code /Applications/Visual\ Studio\ Code.app

echo # visual line break
