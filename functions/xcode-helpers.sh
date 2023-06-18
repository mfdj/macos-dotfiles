#!/bin/sh

ensure_xcode_cli() {
   # if xcode has already installed it will exit with 1
   if xcode-select --install 2> /dev/null; then
      # is there is a way to check this w/o sudo?
      sudo xcodebuild -license 2> /dev/null
   elif [ "${DO_UPDATES:-}" ]; then
      softwareupdate --install -a 'Command Line Tools'
   fi
}
