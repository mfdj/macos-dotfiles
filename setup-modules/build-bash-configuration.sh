#!/usr/bin/env bash

require functions/append-source
require functions/brew-helpers

# + + + + + + + + + + + + + + + +
# +  dotfiles bootstrap files   +
# +  ~/.{bash_profile,bashrc}   +
# + + + + + + + + + + + + + + + +

BASH_CONFIG_FILE=~/.bashrc

echo Pointing .bash_profile at .bashrc
# this shellcheck is a false positive - we're echoing a dollar sign, not evaluting here
# shellcheck disable=SC2016
echo '[[ -n $PS1 ]] && source ~/.bashrc' > ~/.bash_profile

# - clobber bash_profile so we can append to it

echo 'Building .bashrc'

{
   echo "# $USER bashrc build started $(date '+%Y-%m-%d %T')"

   # reset PATH variable so re-sourcing doesn't gunk up the profile
   PATH='' /usr/libexec/path_helper -s

   # bind DOTFILES_DIR to this pacakge
   echo "export DOTFILES_DIR=$DOTFILES_DIR"
} > "$BASH_CONFIG_FILE"

# ----------- STATIC --------------
#     (simply appends files)

# reuse custom wrapper to install + bootstrap brew command
append_source "$DOTFILES_DIR/functions/brew-helpers.sh" "$BASH_CONFIG_FILE"
echo "ensure_brew_ready" >> "$BASH_CONFIG_FILE"

# startup-cost: 0m0.025s
append_source "$DOTFILES_DIR/bash-configuration" "$BASH_CONFIG_FILE"

# startup-cost: 0m0.004s
append_source "$DOTFILES_DIR/functions" "$BASH_CONFIG_FILE"

# ----------- DYNAMIC --------------

# NOTE: before running dynamic elements source current static config
# shellcheck disable=SC1090
source "$BASH_CONFIG_FILE"
if [[ -f "$DOTFILES_DIR/local/bashrc.sh" ]]; then
   # shellcheck source=../local/bashrc.sh
   source "$DOTFILES_DIR/local/bashrc.sh"
fi

# startup-cost: 0m0.193s
append_source "$DOTFILES_DIR/bash-configuration/dynamic" "$BASH_CONFIG_FILE" --exectue

# use bash-completion package if installed
if [[ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]]; then
   # shellcheck source=/opt/homebrew/share/bash-completion/bash_completion
   echo "source '$(brew --prefix)/share/bash-completion/bash_completion'" >> "$BASH_CONFIG_FILE"
fi

# ----------- LOCAL-STATIC --------------
#     (append last for full control)

# startup-cost: 0m0.001s
if [[ -f "$DOTFILES_DIR/local/bashrc.sh" ]]; then
   append_source "$DOTFILES_DIR/local/bashrc.sh" "$BASH_CONFIG_FILE"
fi

hash_value=$(shasum "$BASH_CONFIG_FILE" | awk '{print $1}')
{
   echo "# $USER bashrc built $(date '+%Y-%m-%d %T')"
   echo "# with shasum: ${hash_value}"
   echo "# ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~"
   echo "# 3rd party appends below 👇"
   echo
} >> "$BASH_CONFIG_FILE"
