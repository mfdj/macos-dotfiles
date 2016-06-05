# shellcheck disable=SC2148

# promptfor variable-name prompt
promptfor() {
   local is_secret
   [[ $1 == 'secret' ]] && { is_secret=true; shift; }

   local export_name=$1
   local prompt=$2
   local default_value="${!export_name}" # evaluate current value as default
   local user_value

   [[ -z $prompt ]] && {
      prompt="Set ${export_name//_/-}"
   }

   if [[ -z $default_value ]]; then
      # if default_value empty then require an input
      while [[ -z $user_value ]]; do
         echo -en "$prompt: "
         if   [[ $is_secret ]]
         then read -s user_value; echo
         else read user_value
         fi
         if   [[ -z $user_value ]]
         then echo "(error: input can't be empty)"
         else eval $export_name="'$user_value'"
         fi
      done
   else
      # default_value not empty
      if   [[ $is_secret ]]
      then echo -en "$prompt [ -secret default- ] "; read -s user_value; echo
      else echo -en "$prompt [$default_value] "; read user_value
      fi
      if   [[ -z $user_value ]]
      then eval $export_name="'$default_value'"
      else eval $export_name="'$user_value'"
      fi
   fi
}

promptifempty() {
   local is_secret
   [[ $1 == 'secret' ]] && { is_secret=true; shift; }

   local prompt="$1"
   local export_name="$2"
   local current_value="${!export_name}"
   local default_value="$3"

   if [[ -z $current_value ]]; then
      [[ $is_secret ]] \
         && promptwith secret "$prompt" "$export_name" "$default_value" \
         || promptwith "$prompt" "$export_name" "$default_value"
   else
      [[ $is_secret ]] \
         && echo "$prompt: (already set in "\$"${export_name})" \
         || echo "$prompt: (already set '${!export_name}' in "\$"${export_name})"
   fi
}

whenready() {
   echo -n "$1 [enter when ready] " && read _ignore_
}

is_yes() {
   local toggled is_true
   ! shopt -s | grep 'nocasematch' -q && {
      toggled=true
      shopt -s nocasematch
   }

   [[ $1 =~ ye?s? || $1 =~ true ]] && is_true=true;
   [[ $toggled ]] && shopt -u nocasematch
   [[ $is_true ]] && return 0 || return 1
}
