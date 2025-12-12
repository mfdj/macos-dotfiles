#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring cask-optional packages

cask_ensure  charles
cask_ensure  firefox
cask_ensure  kap
cask_ensure  licecap
cask_ensure  murus
cask_ensure  openoffice
cask_ensure  rubymine
cask_ensure  processing
cask_ensure  screenflow
cask_ensure  vlc

echo # visual line break
