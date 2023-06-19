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
# sources script relative to DOTFILES_DIR
#
sourcedot() {
   if [[ ${DO_QUIETLY:-} ]]; then
      # shellcheck disable=SC1090
      source "$DOTFILES_DIR/$1.sh" &> /dev/null
   elif [[ $1 =~ setup-modules ]]; then
      echo -e "\n============ ${1##*setup-modules/} ============"

      if [[ ${DO_TIME:-} ]]; then
         # shellcheck disable=SC1090
         time source "$DOTFILES_DIR/$1.sh"
      else
         # shellcheck disable=SC1090
         source "$DOTFILES_DIR/$1.sh"
      fi
   else
      # shellcheck disable=SC1090
      source "$DOTFILES_DIR/$1.sh"
   fi
}
export -f sourcedot
