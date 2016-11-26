#!/usr/bin/env bash

require 'functions/brew-helpers'

brew_ensure  blueutil # control bluetooth
brew_ensure  casperjs casperjs --devel
brew_ensure  direnv # Load/unload environment variables based on $PWD
brew_ensure  gnupg2 # http://superuser.com/questions/655246/are-gnupg-1-and-gnupg-2-compatible-with-each-other
brew_ensure  htop-osx
brew_ensure  hhvm hhvm/hhvm/hhvm
brew_ensure  icu4c # for intl
brew_ensure  gawk # GNU awk
brew_ensure  goaccess # Log analyzer and interactive viewer for the Apache Webserver
brew_ensure  imagemagick
brew_ensure  libsodium # crypto
brew_ensure  mongodb # Webscale
brew_ensure  multitail # Tail multiple files in one terminal simultaneously
brew_ensure  n98-magerun2
brew_ensure  pdfgrep
brew_ensure  phantomjs
brew_ensure  pyenv
brew_ensure  qt5 # For webkit things like capybara
brew_ensure  rabbitmq-c
brew_ensure  redis
#brew_ensure  screen # http://dominik.honnef.co/posts/2010/10/why_you_should_try_tmux_instead_of_screen/
brew_ensure  tmux
brew_ensure  valgrind # Dynamic analysis tools (memory, debug, profiling)
brew_ensure  watchman # file-watcher

# osx el-cap has very up-to-date versions of:
# • curl --version -> system: 7.43.0 - homebrew: 7.49.0
# brew_ensure curl
# • expect -v -> system: 5.45 - homebrew: 5.45
# brew_ensure homebrew/dupes/expect
