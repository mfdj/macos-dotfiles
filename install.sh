#!/usr/bin/env bash

# NOTE: setup-modules/_env.bash will also set DOTFILES_DIR (if it's unset) so we
# use INSTALL_INTO to differneatie
INSTALL_INTO=${DOTFILES_DIR:-$HOME/dotfiles}
echo "Installing dotfiles into $INSTALL_INTO"

if [[ -f "$INSTALL_INTO/setup-modules/_env.bash" ]]; then
   # shellcheck source=./setup-modules/_env.bash
   source "$INSTALL_INTO/setup-modules/_env.bash"
elif [[ -f setup-modules/_env.bash ]]; then
   source setup-modules/_env.bash
else
   echo 'Error: could not source setup-modules/_env.bash'
   echo 'Tip: either set DOTFILES_DIR or run this script from that directory.'
   exit 1
fi

require functions/ssh-helpers
require functions/brew-helpers

ensure_brew_ready
sourcedot brewfiles/essential

ensure_ssh_key

if [[ -d $INSTALL_INTO ]]; then
   (
      cd "$INSTALL_INTO"
      if git status --short --branch; then
         echo Valid repository

         if git remote -v | grep -q https; then
            echo "Error: $INSTALL_INTO was cloned over https - git protocol is required to receive updates"
            # TODO: add option to backup and clean current INSTALL_INTO directory so installer can continue
            exit 1
         fi

         # TODO: make expected git origin configurable
         if ! git remote -v | grep -q 'mfdj/macos-dotfiles'; then
            echo "Error: $INSTALL_INTO was not cloned from expected origin (mfdj/macos-dotfiles)"
            exit 1
         fi

         if ! git fetch; then
            echo Ensure Github has the public key
            cat ~/.ssh/id_ed25519.pub
            echo 'open https://github.com/settings/keys'
            exit 1
         fi
      else
         echo "Error: $INSTALL_INTO was not git cloned"
         exit 1
      fi
   )
else
   if ! git clone git@github.com:mfdj/macos-dotfiles.git "$INSTALL_INTO"; then
      echo Ensure Github has the public key
      cat ~/.ssh/id_ed25519.pub
      echo 'open https://github.com/settings/keys'
      exit 1
   fi
fi

# Ready to setup
export DOTFILES_DIR=${INSTALL_INTO}
cd "$DOTFILES_DIR"
./setup.sh
