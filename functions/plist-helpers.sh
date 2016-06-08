# shellcheck disable=SC2148

plist_set_array() {
   plistbuddy=${plistbuddy:-/usr/libexec/PlistBuddy}
   local plist=$1; shift
   local key=$1; shift
   local datatype

   # test if we need to delete the path
   if $plistbuddy "$plist" -c "print '$key'" &> /dev/null; then
      $plistbuddy "$plist" -c "delete '$key'"
   fi

   # try adding to that key
   if ! $plistbuddy "$plist" -c "add '$key' array" &> /dev/null; then
      echo "invalid key-path '$key'"
      return
   fi

   for value in "$@"; do
      if [[ $value =~ ^[0-9]+$ ]]; then
         datatype=integer
      elif [[ $value =~ ^[0-9]+\.[0-9]+$ ]]; then
         datatype=real
      else
         datatype=string
      fi

      $plistbuddy "$plist" -c "add '$key': $datatype $value"
   done
}

plist_disable() {
   plistbuddy=${plistbuddy:-/usr/libexec/PlistBuddy}
   local plist=$1
   local key=$2

   if $plistbuddy "$plist" -c "print '$key'" &> /dev/null; then
      $plistbuddy "$plist" -c "delete '$key'" 2> /dev/null
   fi

   $plistbuddy "$plist" -c "add '$key' dict"
   $plistbuddy "$plist" -c "add '$key':enabled bool"
   $plistbuddy "$plist" -c "set '$key':enabled false"
}
