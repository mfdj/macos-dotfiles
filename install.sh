#!/usr/bin/env bash

if [[ ${DOTFILES_DIR:-} ]] && [[ -f "$DOTFILES_DIR/setup-modules/_env.bash" ]]; then
   # shellcheck source=./setup-modules/_env.bash
   source "$DOTFILES_DIR/setup-modules/_env.bash"
elif [[ -f setup-modules/_env.bash ]]; then
   source setup-modules/_env.bash
else
   echo 'Error: could not source setup-modules/_env.bash'
   echo 'Tip: either set DOTFILES_DIR or run this script from that directory.'
   exit 1
fi

require functions/ssh-helpers
require functions/brew-helpers

ensure_brew_command
rundot brewfiles/essential

ensure_ssh_key

echo "Ensuring dotfiles are cloned to $HOME/dotfiles"
if [[ -d ~/dotfiles ]]; then
   (
      cd ~/dotfiles
      git status || {
         echo "Error: $HOME/dotfiles was not git cloned"
      }
   )
else
   if ! git clone git@github.com:mfdj/macos-dotfiles.git ~/dotfiles; then
      echo "Ensure Github has the public key"
      cat ~/.ssh/id_ed25519.pub
      echo 'open https://github.com/settings/keys'
   fi
fi
