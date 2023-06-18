#!/usr/bin/env bash

ensure_ssh_key() {
   echo Ensuring appropriate SSH key exists
   if [[ ! -f ~/.ssh/id_ed25519 ]]; then
      echo 'Generating new ssh key (ed25519)'
      # NOTE: the default file path is ~/.ssh/id_${algo}
      # NOTE: will interactively prompt for a passphrase.
      ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
   fi
}
