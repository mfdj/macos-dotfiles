#!/usr/bin/env bash

require 'functions/brew-helpers'

brew_ensure  blueutil # control bluetooth
brew_ensure  casperjs casperjs --devel
brew_ensure  direnv # Load/unload environment variables based on $PWD
brew_ensure  figlet
brew_ensure  grc # Generic Colouriser `grc ps aux`
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
brew_ensure  pdfgrep
brew_ensure  phantomjs
brew_ensure  pv # monitor data's progress through a pipe
brew_ensure  pyenv
brew_ensure  qt5 # For webkit things like capybara
brew_ensure  rabbitmq-c
brew_ensure  redis
brew_ensure  tmux
brew_ensure  valgrind # Dynamic analysis tools (memory, debug, profiling)
brew_ensure  watchman # file-watcher

# macOS up-to-date versions of:
#
# curl (curl --version)
# • sierra --> system: 7.49.1 - homebrew: 7.52.1 (feb 2017)
# • el-cap --> system: 7.43.0 - homebrew: 7.49.0
#
# homebrew/dupes/expect (expect -v)
# • system: 5.45 - homebrew: 5.45 (Poured from bottle on 2016-03-25)
