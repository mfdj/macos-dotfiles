# shellcheck disable=SC2148

powersave() {
   if [[ -f ${DOTFILES_DIR}/local/powerave.shush ]]; then
      (
         IFS=$'\n'
         while read proc; do
            shush "$proc"
         done < "${DOTFILES_DIR}"/local/powerave.shush
      )
   fi

   open -a 'App Tamer' 2> /dev/null || echo "App Tamer not installed"
}
