#!/usr/bin/env bash

#
# Will display or generate an an SSH key in the preferred format.
#  • will interactively prompts for a passphrase during generation
#
ensure_ssh_key() {
   if [[ -f ~/.ssh/id_ed25519 ]]; then
      echo Found SSH key ~/.ssh/id_ed25519
      ssh-keygen -l -f ~/.ssh/id_ed25519
   else
      echo 'Generating new ssh key (ed25519)'
      # • pass -f so it doesn't prompt for output_keyfile; conventional default is ~/.ssh/id_${algo}
      # • don't pass -C since the default comment "$(whoami)@$(scutil --get ComputerName)" is good
      ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
   fi

   # if key is encrypted this command will exit with 255 because -P '' passes an empty passphrase
   if ! ssh-keygen -y -P '' -f ~/.ssh/id_ed25519 &> /dev/null; then
      echo 'Adding encrypted key to keychain'
      # prior to macOS 12 you would ssh-add -K …
      ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   fi
}
