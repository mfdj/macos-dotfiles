#!/usr/bin/env bash

powersave() {
   if [[ -f ${DOTFILES_DIR}/local/powersave.shush ]]; then
      (
         IFS=$'\n'
         while read proc; do
            shush "$proc"
         done < "${DOTFILES_DIR}"/local/powersave.shush
      )
   fi

   open -a 'App Tamer' 2> /dev/null || echo "App Tamer not installed"
}
