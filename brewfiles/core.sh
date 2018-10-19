#!/usr/bin/env bash

require 'functions/brew-helpers'

# newer versions than macos (as of oct'18)
brew_ensure  bash       # macOS: 3.2.57   < brew: 4.4.23
brew_ensure  git        # macOS: 2.17.1   < brew: 2.19.1
brew_ensure  openssl    # macOS: 0.9.8hzh < brew: 1.0.2p - not linked
brew_ensure  rsync      # macOS: 2.6.9    < brew: 3.1.3

# variant implemenations of BSD's builtins/commands
brew_ensure  coreutils # see: https://www.gnu.org/software/coreutils/manual/html_node/index.html
brew_ensure  grep      # `ggrep` gnu-grep

# not on macos
brew_ensure  apache-httpd
brew_ensure  bash-completion@2 # for bash 4.1+
brew_ensure  blueutil # control bluetooth
brew_ensure  colordiff
brew_ensure  ccat # cat with syntax highlighting for popular programming languages
brew_ensure  diff-so-fancy
brew_ensure  grc # Generic Colouriser `grc ps aux`
brew_ensure  hub
brew_ensure  htop-osx
brew_ensure  jq
brew_ensure  md5sha1sum
brew_ensure  multitail # Tail multiple files in one terminal simultaneously
brew_ensure  php
brew_ensure  pidof
brew_ensure  pstree
brew_ensure  ripgrep # `rg`
brew_ensure_command rbenv # there may be a custome-build
brew_ensure  ruby-build
brew_ensure_command shellcheck # there may be a custom-build; see setup.sh
brew_ensure  tree
brew_ensure  vcprompt
brew_ensure  wget
