#!/usr/bin/env bash

require 'functions/brew-helpers'

cask_ensure  charles
cask_ensure  firefox
cask_ensure  kap
cask_ensure  licecap
cask_ensure  lighttable
cask_ensure  murus
cask_ensure  openoffice
cask_ensure  rubymine
cask_ensure  processing
cask_ensure  screenflow
cask_ensure  sublime-text
# https://apple.stackexchange.com/questions/422565/does-virtualbox-run-on-apple-silicon
# cask_ensure  vagrant
# cask_ensure  virtualbox
cask_ensure  vlc
