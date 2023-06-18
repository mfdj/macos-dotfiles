#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

export DOTFILES_DIR
if ! [[ ${DOTFILES_DIR:-} ]]; then
   cd "$(dirname "$0")"
   DOTFILES_DIR="$(pwd -P)"
fi

#
#
#
require() {
   # shellcheck disable=SC1090
   source "$DOTFILES_DIR/$1.sh"
}
export -f require

#
#
#
rundot() {
   if [[ ${DO_QUIETLY:-} ]]; then
      "$DOTFILES_DIR/$1.sh" > /dev/null
   elif [[ $1 =~ setup-modules ]]; then
      echo -e "\n============ ${1##*setup-modules/} ============"

      if [[ ${DO_TIME:-} ]]; then
         time source "$DOTFILES_DIR/$1.sh"
      else
         source "$DOTFILES_DIR/$1.sh"
      fi
   else
      source "$DOTFILES_DIR/$1.sh"
   fi
}
export -f rundot
