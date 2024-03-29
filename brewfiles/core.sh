#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring core packages

# newer versions than macos (as of march'19)
brew_ensure  bash       # macOS: 3.2.57   < brew: 5.0.3
brew_ensure  git        # macOS: 2.39.2   < brew: 2.21.0
brew_ensure  openssl    # macOS: 0.9.8hzh < brew: 1.0.2r - not linked
brew_ensure  rsync      # macOS: 2.6.9    < brew: 3.1.3

# variant implemenations of BSD's builtins/commands
brew_ensure  coreutils # see: https://www.gnu.org/software/coreutils/manual/html_node/index.html

# not on macos
brew_ensure  bash-completion@2 # for bash 4.1+
brew_ensure  bat
brew_ensure  colordiff
brew_ensure  ctop
brew_ensure  diff-so-fancy
brew_ensure  fpp
brew_ensure  git-delta
brew_ensure  grc # Generic Colouriser `grc ps aux`
brew_ensure  htop-osx
brew_ensure  jq
brew_ensure  nodenv
brew_ensure  pidof
brew_ensure  pstree
brew_ensure  ripgrep # `rg`
brew_ensure_command rbenv # there may be a custom-build
brew_ensure  ruby-build
brew_ensure  tree
brew_ensure  vcprompt
brew_ensure  wget

echo # visual line break
