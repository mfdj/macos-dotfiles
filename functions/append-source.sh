# shellcheck disable=SC2148

append_source() {
   local source_path=$1
   local append_to=$2
   local execute
   local paths

   [[ $3 == --exectue ]] && execute=true

   # wrap paths in an array
   [[ -f $source_path ]] && paths=("$source_path")
   [[ -d $source_path ]] && paths=("$source_path"/*)

   # shellcheck disable=SC2128
   [[ $paths ]] || {
      echo "did not find anything at '$source_path'?"
      return 1
   }

   for file in "${paths[@]}"; do
      if [[ $execute ]]; then
         if [[ -f $file && -x $file ]]; then
            echo "# execute '$file'" >> "$append_to"
            # shellcheck disable=SC1090
            source $file >> "$append_to"
         else
            echo "append-source - '$file' is not executable?"
         fi
      elif [[ -f $file ]]; then
         echo "# append '$file'" >> "$append_to"
         echo "source $file" >> "$append_to"
      elif [[ -d $file ]]; then
         # ignore folders
         :
      elif [[ $file ]]; then # not blank
         echo "append-source - skipping '$file'?"
      fi
   done
}
