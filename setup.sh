#!/usr/bin/env bash

[[ $DOTFILES_DIR ]] || {
   cd "$(dirname "$0")" || { echo 'could not resolve path'; exit 1; }
   DOTFILES_DIR="$(pwd -P)"
}

# parse configuration options
index=1
while [[ $index -le $# ]]; do
   word=${!index} && shift
   case $word in
    optional) DO_OPTIONAL=true;;
        cask) DO_CASK=true;;
      update|upgrade) DO_UPDATES=true;;
       clean) DO_CLEAN=true;;
     q|quiet) DO_QUIETLY=true;;
        time) DO_TIME=true;;
   esac
done

export DOTFILES_DIR
export DO_OPTIONAL
export DO_CASK
export DO_UPDATES
export DO_CLEAN
export DO_QUIETLY
export DO_TIME

# log() {
#    local verbose
#    local quiet
#    local normal
#
#    while [[ $index -le $# ]]; do
#       word=${!index} && shift
#       case $word in
#        verbose) DO_OPTIONAL=true;;
#          quiet) DO_CASK=true;;
#       *|normal) DO_UPDATES=true;;
#       esac
#    done
# }

require() {
   # shellcheck disable=SC1090
   source "$DOTFILES_DIR/$1.sh"
}

export -f require

# shellcheck disable=SC1090
rundot() {
   if [[ $DO_QUIETLY ]]; then
      "$DOTFILES_DIR/$1.sh" > /dev/null
   elif [[ $1 =~ setup-modules ]]; then
      echo -e "\n============ ${1##*setup-modules/} ============"

      if [[ $DO_TIME ]]; then
         time "$DOTFILES_DIR/$1.sh"
      else
         "$DOTFILES_DIR/$1.sh"
      fi
   else
      "$DOTFILES_DIR/$1.sh"
   fi
}

export -f rundot

rundot setup-modules/packages-and-tools
rundot setup-modules/application-configuration
rundot setup-modules/macos-core
[[ $DO_OPTIONAL ]] && rundot setup-modules/macos-optional
rundot setup-modules/build-bash-configuration

[[ $DO_QUIETLY ]] || {
   echo
   echo '============ Finished ============'
   echo
   echo Rebuilt ~/.bashrc
   echo
}
