#!/usr/bin/env bash

### bash-completions installed by homebrew; see: /usr/local/etc/bash_completion.d
find /usr/local/etc/bash_completion.d -type l -exec echo "[[ -f '{}' ]] && source '{}'" \;

### n, node.js version manager
# startup-cost: 0
[[ -d ~/.n ]] && {
   echo "export N_PREFIX=${HOME}/.n"
   echo "PATH=${N_PREFIX}/bin:\${PATH}"  # Added by n-install (see http://git.io/n-install-repo).
}

# nvm startup-cost: 0m0.590s — ~80% of the time of this module
# [[ -f ~/.nvm/nvm.sh          ]] && echo source ~/.nvm/nvm.sh
# n completions startup-cost: 0m0.076s
# [[ -r ~/.nvm/bash_completion ]] && echo source ~/.nvm/bash_completion
# nvm-total startup-cost: 0m0.640s

# NOTE: switching both rbenv/pyenv to static-init gets about 0.15s gain (from 0.5s to 0.35s total bash_profile - so ~1.4x increase)
# NOTE: 99% of rbenv/pyenv init cost comes from the `rehash` - can this be backgrounded?

# test if var is set: https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
[[ ${ENV_HELPER_STATIC+x} ]] || ENV_HELPER_STATIC=1

### pyenv
command -v pyenv > /dev/null && {
   if [[ $ENV_HELPER_STATIC ]]; then
      echo "$(pyenv init -)"
   else
      echo 'eval "$(pyenv init -)"'
   fi
}

### rbenv
[[ -d ~/.rbenv.d ]] && {
   echo "PATH=${HOME}/.rbenv.d/bin:\${PATH}"
}

command -v rbenv > /dev/null && {
   if [[ $ENV_HELPER_STATIC ]]; then
      echo "$(rbenv init -)"
   else
      echo 'eval "$(rbenv init -)"'
   fi
}
