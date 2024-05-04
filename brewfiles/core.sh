#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring core packages

# newer versions than macos (as of 2024-may)
brew_ensure  bash     # brew: 5.2.26  macOS: /bin/bash --version       3.2.57(1)-release (arm64-apple-darwin23)
brew_ensure  git      # brew: 2.44.0  macOS: /usr/bin/git --version    2.39.3 (Apple Git-146)
brew_ensure  rsync    # brew: 3.1.3   macOS: /usr/bin/rsync --version  2.6.9 protocol version 29

# NOTE: macOS (circa 2015 https://en.wikipedia.org/wiki/OS_X_El_Capitan) adopted libressl to replace openssl
# "libressl is keg-only, which means it was not symlinked into /opt/homebrew"
brew_ensure  libressl # brew: 3.3.9   macOS: /usr/bin/openssl version  LibreSSL 3.3.6

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
brew_ensure  htop
brew_ensure  jq
brew_ensure  nodenv
brew_ensure  pidof
brew_ensure  pstree
brew_ensure_command rbenv # there may be a custom-build
brew_ensure  ruby-build
brew_ensure  tree
brew_ensure  vcprompt
brew_ensure  wget

echo # visual line break
