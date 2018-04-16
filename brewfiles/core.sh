#!/usr/bin/env bash

require 'functions/brew-helpers'

# newer versions than macos (as of feb'18)
brew_ensure  bash                       # macOS: 3.2.57   < brew: 4.4.19
brew_ensure  git                        # macOS: 2.14.3   < brew: 2.16.1
brew_ensure  openssl                    # macOS: 0.9.8hzh < brew: 1.0.2n - not linked
brew_ensure  rsync homebrew/dupes/rsync # macOS: 2.6.9    < brew: 3.1.3

# variant implemenations of BSD's builtins/commands
brew_ensure  coreutils # see: https://www.gnu.org/software/coreutils/manual/html_node/index.html
brew_ensure  grep homebrew/dupes/grep # `ggrep` gnu-grep

# not on macos
brew_ensure  bash-completion@2 # for bash 4.1+
brew_ensure  colordiff
brew_ensure  diff-so-fancy
brew_ensure  hub
brew_ensure  jq
brew_ensure  md5sha1sum
brew_ensure  pidof
brew_ensure  pstree
brew_ensure  ripgrep # `rg`
brew_ensure  rbenv
brew_ensure  rbenv-vars
brew_ensure  ruby-build
#brew_ensure  shellcheck - see custom-build in setup.sh
brew_ensure  tree
brew_ensure  vcprompt
brew_ensure  wget
