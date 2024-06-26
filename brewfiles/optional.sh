#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring optional packages

brew_ensure  apache-httpd
brew_ensure  blueutil # control bluetooth
brew_ensure  composer
brew_ensure  direnv # Load/unload environment variables based on $PWD
brew_ensure  figlet
brew_ensure  icu4c # for intl
brew_ensure  gawk # GNU awk
brew_ensure  goaccess # Log analyzer and interactive viewer for the Apache Webserver
brew_ensure  imagemagick
brew_ensure  libsodium # crypto
brew_ensure  multitail # Tail multiple files in one terminal simultaneously
brew_ensure  mysql
brew_ensure  pdfgrep
brew_ensure  php
brew_ensure  pv # monitor data's progress through a pipe
brew_ensure  pyenv
brew_ensure  qt@5 # For webkit things like capybara
brew_ensure  rabbitmq-c
brew_ensure  redis
brew_ensure  tmux
# valgrind is no longer tractable on macos https://stackoverflow.com/questions/40650338/valgrind-on-macos-sierra
brew_ensure  watchman # file-watcher

echo # visual line break
