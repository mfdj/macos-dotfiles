#!/usr/bin/env bash

require functions/brew-helpers
require functions/xcode-helpers

echo Ensuring Homebrew
ensure_brew_ready

echo Ensuring XCode Command Line Tools
ensure_xcode_cli

if [[ $DO_UPDATES ]]; then
   brew update
fi

sourcedot brewfiles/essential
sourcedot brewfiles/core

if [[ $DO_OPTIONAL             ]]; then sourcedot brewfiles/optional      ; fi
if [[ $DO_CASK                 ]]; then sourcedot brewfiles/cask-core     ; fi
if [[ $DO_CASK && $DO_OPTIONAL ]]; then sourcedot brewfiles/cask-optional ; fi

if [[ $DO_UPDATES ]]; then brew upgrade ; fi
if [[ $DO_CLEAN   ]]; then brew cleanup ; fi
