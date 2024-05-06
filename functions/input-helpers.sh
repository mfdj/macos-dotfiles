#!/usr/bin/env bash

# promptfor variable-name prompt
promptfor() {
   local is_secret=''
   if [[ $1 == 'secret' ]]; then 
      is_secret=true
      shift
   fi

   local export_name=$1
   local prompt=$2
   local default_value="${!export_name}" # evaluate current value as default
   local user_value=''

   if [[ -z $prompt ]]; then
      prompt="Set ${export_name//_/-}"
   fi

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
   local is_secret=''
   if [[ $1 == 'secret' ]]; then 
      is_secret=true
      shift
   fi

   local prompt="$1"
   local export_name="$2"
   local current_value="${!export_name}"
   local default_value="$3"

   if [[ -z $current_value ]]; then
      if  [[ $is_secret ]]
      then promptwith secret "$prompt" "$export_name" "$default_value"
      else promptwith "$prompt" "$export_name" "$default_value"
      fi
   else
      if   [[ $is_secret ]]
      then echo "$prompt: (already set in "\$"${export_name})"
      else echo "$prompt: (already set '${!export_name}' in "\$"${export_name})"
      fi
   fi
}

whenready() {
   local __ignore
   
   # shellcheck disable=2034
   if echo -n "$1 [enter when ready] "; then 
     read __ignore
   fi
}

is_yes() {
   [[ $1 =~ ^[yY][eE]?[sS]?$ ]]
}
