#!/usr/bin/env bash

### bash-completions installed by homebrew; see: /usr/local/etc/bash_completion.d
find /usr/local/etc/bash_completion.d -type l -exec echo "[[ -f '{}' ]] && source '{}'" \;

# NOTE: switching rbenv/etc. to static-init gets about 0.165s gain (from 0.5s to 0.335s total bash_profile - so ~1.4x increase)
# NOTE: 99% of rbenv/etc. init cost comes from the `rehash` - can this be backgrounded?

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

### nodenv
command -v nodenv > /dev/null && {
   if [[ $ENV_HELPER_STATIC ]]; then
      echo "$(nodenv init -)"
   else
      echo 'eval "$(nodenv init -)"'
   fi
}
