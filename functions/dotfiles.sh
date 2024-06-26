#!/usr/bin/env bash

dotfiles() {
   DOTFILES_DIR=${DOTFILES_DIR:-~/dotfiles}

   if [[ $# == 0 || $1 == help ]]; then
      echo "
dotfiles <command> <options>

commands:
  help                  this screen
  setup <options>       rebuild dotfiles (using setup script)
  reload                restart the shell session (aka reload ~/.bash_profile)
  edit                  change to dotfiles and open them in '$EDITOR'
  scripts               list scripts to run
  run <name> <options>  run a script
"
      return
   fi

   local cmd=$1
   shift

   # -=-=-=- setup -=-=-=-

   if [[ $cmd == setup ]]; then
      local index=1
      local do_reload
      local word

      # intercept and extract reload from arguments-list
      while [[ $index -le $# ]]; do
         word=${!index}
         case $word in
            reload)
               do_reload=true
               if [[ $index -gt 1 ]]; then
                  set -- "${@:1:((index - 1))}" "${@:((index + 1)):$#}"
               else
                  set -- "${@:((index + 1)):$#}"
               fi
            ;;
         esac
         ((index++))
      done

      # run setup-script with arguments
      "$DOTFILES_DIR"/setup.sh "$@"

      # TODO: add comparison between runs (to highlight differences)
      # shellcheck disable=SC1090
      time source ~/.bash_profile

      if [[ $do_reload ]]; then
         dotfiles reload
      fi

      return
   fi

   # -=-=-=- run -=-=-=-

   if [[ $cmd == run ]]; then
      local script_name
      local script_path

      script_name="${1%.sh}"
      shift
      script_path="$DOTFILES_DIR/scripts/${script_name}.sh"

      if [[ -z $script_name ]]; then
         echo 'missing script-name argument - valid script-names:'
         dotfiles scripts
         return
      fi

      [[ -f $script_path ]] || {
         echo "could not find ${script_name}.sh in ${DOTFILES_DIR}/scripts - valid script-names:"
         dotfiles scripts
         return
      }

      [[ -x $script_path ]] || {
         echo "$script_path not executable"
         return
      }

      export -f dotfiles
      $script_path "$@"

      return
   fi

   # -=-=-=- reload -=-=-=-

   if [[ $cmd == reload ]]; then
      echo "============ reloading shell ============"
      # shellcheck disable=SC1090
      exec /usr/bin/env bash -l
   fi

   # -=-=-=- edit -=-=-=-

   if [[ $cmd == edit ]]; then
      cd "$DOTFILES_DIR" && {
         if [[ $1 == local ]]; then
            $EDITOR ./local
         else
            $EDITOR ./
         fi
      }

      return
   fi

   # edit, scripts
   case $cmd in
      scripts) ( cd "$DOTFILES_DIR"/scripts && find -- * -name '*.sh' | rev | cut -c4- | rev );;
            *) echo "don't understand '$cmd'";;
   esac
}
