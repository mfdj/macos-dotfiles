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
      update) DO_UPDATES=true;;
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
run_module() {
   if [[ $DO_QUIETLY ]]; then
      "$DOTFILES_DIR/setup-modules/$1.sh" > /dev/null
   else
      echo -e "\n============ $1 ============"
      # log \
      #    verbose "\n============ $1 ============" \
      #    quiet "run: $1"

      if [[ $DO_TIME ]]; then
         "$DOTFILES_DIR/setup-modules/$1.sh"
      else
         "$DOTFILES_DIR/setup-modules/$1.sh"
      fi
   fi
}

run_module packages-and-tools
[[ $DO_LANGUAGES ]] && run_module languages
run_module application-configuration
run_module osx-core
[[ $DO_OPTIONAL ]] && run_module osx-optional
run_module build-bash-profile

[[ $DO_QUIETLY ]] || {
   echo '============ Finished ============'
   echo
   echo Rebuilt ~/.bash_profile
}
