#!/usr/bin/env bash

require 'functions/brew-helpers'

# newer versions than macos
brew_ensure  bash
brew_ensure  git
brew_ensure  openssl
brew_ensure  rsync homebrew/dupes/rsync # v3 (osx has v2)

# variant implemenations of BSD's builtins/commands
brew_ensure  coreutils
brew_ensure  grep homebrew/dupes/grep # `ggrep` gnu-grep

# not on macos
brew_ensure  colordiff
brew_ensure  diff-so-fancy
brew_ensure  hub
brew_ensure  jq
brew_ensure  md5sha1sum
brew_ensure  pidof
brew_ensure  ripgrep # `rg`
brew_ensure  rbenv
brew_ensure  rbenv-vars
brew_ensure  ruby-build
brew_ensure  shellcheck
brew_ensure  tree
brew_ensure  vcprompt
brew_ensure  wget
