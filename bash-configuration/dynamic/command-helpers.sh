#!/usr/bin/env bash

# NOTE: switching rbenv/etc. to static-init gets about 0.165s gain (from 0.5s to 0.335s total bash_profile - so ~1.4x increase)
# NOTE: 99% of rbenv/etc. init cost comes from the `rehash` - can this be backgrounded?

# test if var is set: https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
[[ ${ENV_HELPER_STATIC+x} ]] || ENV_HELPER_STATIC=1

if command -v nodenv > /dev/null; then
   if [[ $ENV_HELPER_STATIC ]]; then
      nodenv init -
   else
      # shellcheck disable=SC2016
      echo 'eval "$(nodenv init -)"'
   fi

   # enable prefix-retry hook for nodenv so it can install versions prefixed with `v` (as .nvmrc does)
   echo export NODENV_PREFIX_RETRY=1

   # attempt to locate homebrew installed, then from-source
   if [[ -d $(brew --prefix node-build)/etc ]]; then
      echo export NODENV_HOOK_PATH="$(brew --prefix node-build)/etc/:\${NODENV_HOOK_PATH}"
   fi

   if [[ -d $HOME/from-source/node-build/etc ]]; then
      echo export NODENV_HOOK_PATH="$HOME/from-source/node-build/etc/:\${NODENV_HOOK_PATH}"
   fi
fi

if command -v pyenv > /dev/null; then
   if [[ $ENV_HELPER_STATIC ]]; then
      pyenv init -
   else
      # shellcheck disable=SC2016
      echo 'eval "$(pyenv init -)"'
   fi
fi

if command -v rbenv > /dev/null; then
   # plugin
   if [[ -d ~/.rbenv.d ]]; then
      echo "PATH=${HOME}/.rbenv.d/bin:\${PATH}"
   fi

   if [[ $ENV_HELPER_STATIC ]]; then
      rbenv init -
   else
      # shellcheck disable=SC2016
      echo 'eval "$(rbenv init -)"'
   fi
fi

