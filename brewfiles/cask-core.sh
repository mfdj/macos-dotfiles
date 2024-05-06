#!/usr/bin/env bash

require functions/brew-helpers

echo -n Ensuring cask-core packages

cask_ensure  app-tamer
cask_ensure  flux
# mainline kaleidoscope is version 4; see version 3 installer
#cask_ensure  kaleidoscope
cask_ensure  macdown
cask_ensure  sourcetree
cask_ensure  sequel-pro

# kaleidoscope v3
if which -s ksdiff; then
   echo -n " ✔ kaleidoscope (v3)"
else
   curl https://raw.githubusercontent.com/Homebrew/homebrew-cask/d81b3ccdd74823f6c9ef5f1adbbd6e717e2b1e0a/Casks/kaleidoscope.rb > ~/Downloads/kaleidoscope.rb
   brew install ~/Downloads/kaleidoscope.rb && echo -n " ✔ kaleidoscope (v3)"
   rm ~/Downloads/kaleidoscope.rb || true
fi

# defer to pre-installed software
cask_ensure_unless_directory google-chrome  /Applications/Google\ Chrome.app # at one point installing outside of cask fixed an issue with 1password extension
cask_ensure_unless_directory slack          /Applications/Slack.app

echo # visual line break
