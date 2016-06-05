# shellcheck disable=SC2148

dotfiles() {
   DOTFILES_DIR=${DOTFILES_DIR:-~/dotfiles}

   [[ $# == 0 || $1 == help ]] && {
      echo "
dotfiles <command> <options>

commands:
  help                  this screen
  setup <options>       rebuild dotfiles (using setup script)
  reload                aka 'time source ~/.bash_profile'
  edit                  change to dotfiles and open them in '$EDITOR'
  scripts               list scripts to run
  run <name> <options>  run a script
"
      return
   }

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
      $DOTFILES_DIR/setup.sh "$@"

      [[ $do_reload ]] && dotfiles reload

      return
   fi

   # -=-=-=- run -=-=-=-

   if [[ $cmd == run ]]; then
      local script_name=${1%.sh}
      shift
      local script_path=$DOTFILES_DIR/scripts/${script_name}.sh

      [[ -f $script_path ]] || {
         echo "could not find ${script_name}.sh in ${DOTFILES_DIR}/scripts"
         return
      }

      [[ -x $script_path ]] || {
         echo "$script_path not executable"
         return
      }

      $script_path "$@"

      return
   fi

   # -=-=-=- reload -=-=-=-

   if [[ $cmd == reload ]]; then
      echo && echo "============ reloading bash_profile ============"

      # shellcheck disable=SC1090
      time source ~/.bash_profile

      return
   fi

   # -=-=-=- reload -=-=-=-

   if [[ $cmd == edit ]]; then
      cd "$DOTFILES_DIR" && {
         [[ $1 == local ]] && $EDITOR ./local || $EDITOR ./
      }

      return
   fi

   # edit, scripts
   case $cmd in
      scripts) { cd $DOTFILES_DIR/scripts && find . -name '*.sh' | cut -c 3- | cut -d '.' -f 1; };;
            *) echo "don't understand '$cmd'";;
   esac
}
