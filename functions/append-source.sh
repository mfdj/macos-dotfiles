#!/usr/bin/env bash

append_source() {
   local source_path=$1
   local append_to=$2
   local execute=
   local paths

   [[ ${3:-} == --exectue ]] && execute=true

   # wrap paths in an array
   if [[ -f $source_path ]]; then
      paths=("$source_path")
   elif [[ -d $source_path ]]; then
      paths=("$source_path"/*)
   else
      echo "$source_path is neither a file nor directory"
      return 1
   fi

   echo "# Appending $source_path" >> "$append_to"

   # shellcheck disable=SC2128
   [[ $paths ]] || {
      echo "'$source_path' is empty?"
      return 1
   }

   for file in "${paths[@]}"; do
      if [[ $execute ]]; then
         if [[ -f $file && -x $file ]]; then
            echo "# Executing '$file'" >> "$append_to"
            # shellcheck disable=SC1090
            source "$file" >> "$append_to"
         else
            echo "append-source - '$file' is not executable?"
         fi
      elif [[ -f $file ]]; then
         echo "source $file" >> "$append_to"
      elif [[ -d $file ]]; then
         # ignore folders
         :
      elif [[ $file ]]; then # not blank
         echo "append-source - skipping '$file'?"
      fi
   done
}
