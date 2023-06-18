#!/usr/bin/env bash

require functions/brew-helpers

brew_ensure  direnv # Load/unload environment variables based on $PWD
brew_ensure  figlet
brew_ensure  gnupg2 # http://superuser.com/questions/z55246/are-gnupg-1-and-gnupg-2-compatible-with-each-other
brew_ensure  hhvm hhvm/hhvm/hhvm
brew_ensure  icu4c # for intl
brew_ensure  gawk # GNU awk
brew_ensure  goaccess # Log analyzer and interactive viewer for the Apache Webserver
brew_ensure  imagemagick
brew_ensure  libsodium # crypto
brew_ensure  mongodb
brew_ensure  mysql
brew_ensure  pdfgrep
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
# • sierra (apr 2017) --> system: 7.51.0 - homebrew: 7.54.0 ** https://curl.haxx.se/docs/security.html
# • sierra (feb 2017) --> system: 7.49.1 - homebrew: 7.52.1
# • el-cap (??? 2016) --> system: 7.43.0 - homebrew: 7.49.0
#
# homebrew/dupes/expect (expect -v)
# • system: 5.45 - homebrew: 5.45 (Poured from bottle on 2016-03-25)
