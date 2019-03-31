#!/usr/bin/env bash

require 'functions/append-source'

# + + + + + + + + + + + + + + + +
# +  dotfiles bootstrap files   +
# +  ~/.{bash_profile,bashrc}   +
# + + + + + + + + + + + + + + + +

CONFIG_TARGET=~/.bashrc

# - bash_profile should point at bashrc

echo 'Pointing .bash_profile at .bashrc'
# this shellcheck is a false positive - we're echoing a dollar sign, not evaluting here
# shellcheck disable=SC2016
echo '[[ -n $PS1 ]] && source ~/.bashrc' > ~/.bash_profile

# - clobber bash_profile so we can append to it

echo 'Building .bashrc'
echo "# $USER bashrc build started $(date '+%Y-%m-%d %T')" > "$CONFIG_TARGET"

# - reset PATH variable so re-sourcing doesn't gunk up the profile

# wanted to generate DEFAULT_PATH dynamically, first attempt did not work: DEFAULT_PATH=$(bash --noprofile --norc -c 'echo $PATH')
DEFAULT_PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
echo "PATH=$DEFAULT_PATH" >> "$CONFIG_TARGET"

# - append sources to bashrc

# bind DOTFILES_DIR to this pacakge
echo "export DOTFILES_DIR=$DOTFILES_DIR" >> "$CONFIG_TARGET"

# ----------- STATIC --------------
#     (simply appends files)

# startup-cost: 0m0.025s
append_source  "$DOTFILES_DIR/bash-configuration" "$CONFIG_TARGET"

# startup-cost: 0m0.004s
append_source  "$DOTFILES_DIR/functions" "$CONFIG_TARGET"

# ----------- DYNAMIC --------------
# (exectue's each file as a script)

# NOTE: static elements sourced in this context so dynamic elements are aware of the current environment
# shellcheck disable=SC1090
{
   source "$CONFIG_TARGET"
   [ -f "$DOTFILES_DIR/local/bashrc.sh" ] && source "$DOTFILES_DIR/local/bashrc.sh"
}

# startup-cost: 0m0.193s
append_source "$DOTFILES_DIR/bash-configuration/dynamic" "$CONFIG_TARGET" --exectue

# ----------- LOCAL-STATIC --------------
#     (append last for full control)

# startup-cost: 0m0.001s
[ -f "$DOTFILES_DIR/local/bashrc.sh" ] && append_source "$DOTFILES_DIR/local/bashrc.sh" "$CONFIG_TARGET"

hash_value=$(shasum "$CONFIG_TARGET" | awk '{print $1}')
echo "# $USER bashrc built $(date '+%Y-%m-%d %T')" >> "$CONFIG_TARGET"
echo "# with shasum: ${hash_value}" >> "$CONFIG_TARGET"
echo "# ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~" >> "$CONFIG_TARGET"
echo "# 3rd party appends below 👇" >> "$CONFIG_TARGET"
echo "" >> "$CONFIG_TARGET"
