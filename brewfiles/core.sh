#!/usr/bin/env bash

require 'functions/brew-helpers'

# newer versions than el-captain
brew_ensure  bash
brew_ensure  git
brew_ensure  openssl
brew_ensure  rsync homebrew/dupes/rsync # v3 (osx has v2)

# variant implemenations of BSD's builtins/commands
brew_ensure  coreutils
brew_ensure  grep homebrew/dupes/grep # 'ggrep' gnu-grep

# not on osx
brew_ensure  colordiff # 'cdiff' — rbenv shims this from time to time?
brew_ensure  diff-so-fancy
brew_ensure  jq # parse json from stdin
brew_ensure  md5sha1sum
brew_ensure  pv # monitor data's progress through a pipe
brew_ensure  ripgrep # 'rg' like the-silve-surfer/ack but faster and better yet
brew_ensure  rbenv
brew_ensure  rbenv-vars
brew_ensure  ruby-build # alpha after rbenv… but this might be a load-order mistake (we'll see)
brew_ensure  shellcheck # static analysis and lint tool, for (ba)sh scripts
brew_ensure  tree
brew_ensure  vcprompt
brew_ensure  wget
