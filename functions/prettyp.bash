#!/usr/bin/env bash

#
# "pretty print" makes dealing with shell escape codes much nicer.
#
#   Usage: prettyp <break> <modifier:>color "your message"
#
#   Examples
#    • Bold yellow with a linebreak         prettyp break bold:yellow "my text"
#    • Red "some" followed by Blue "thing"  prettyp red "some"; prettyp blue "thing"
#    • Italic on reverse white              prettyp italic:7 "italic on reverse white"
#
prettyp() {
   local linebreak=''

   local -A color_map=(
      [none]=0
      [bold]=1
      [dim]=2
      [italic]=3
      [underline]=4
      [blink]=5
      [plain]=6
      [default]=6
      [reverse]=7
      [invisible]=8
      # 9—29 all look like plain/default
      [black]=30
      [red]=31
      [green]=32
      [yellow]=33
      [blue]=34
      [magenta]=35
      [turqoise]=36
   )

   local -A modifiers_map=(
      [none]=0
      [bold]=1
      [dim]=2
      [italic]=3
      [underline]=4
      [blink]=5
      [plain]=6
      [default]=6
      [reverse]=7
      [invisible]=8
   )

   if [[ $1 == break ]]; then
      linebreak='\n'
      shift
   fi

   if (($# < 2)); then
      echo "[prettyp] need 2 arguments: style + message"
      return 1
   fi

   local style=$1
   local message=$2
   local modifier=plain
   local color=default
   local modifier_code
   local color_code
   local output=''

   if [[ $style =~ [0-9]:[0-9] ]]; then
      modifier_code=${style%:*} # everything before the first colon
      color_code=${style#*:}      # everything after the first colon
   else
      if [[ $style =~ [0-9]:[a-z] ]]; then
         modifier_code=${style%:*}
         color=${style#*:}
      elif [[ $style =~ [a-z]:[0-9] ]]; then
         modifier=${style%:*}
         color_code=${style#*:}
      elif [[ $style =~ : ]]; then
         modifier=${style%:*}
         color=${style#*:}
      else
         color=$style
      fi

      # NOTE: when set -o nounset is used and color/modifier are not present in color_map/modifiers_map
      # the next 2 lines will emit cryptic errors like
      #  * modifiers_map[$modifier]: unbound variable
      #  * color_map[$color]: unbound variable
      # It would be nice to emit a more user friendly error message but when nonunset is enabled there's no
      # striaghtfoward way to test if a key exists on an associative array… there are _ugly_ ways but they are
      # not worth the effort. The cryptic error is less friendly but more maintainable.
      if [[ -z ${modifier_code:-} ]]; then modifier_code="${modifiers_map[$modifier]}"; fi
      if [[ -z ${color_code:-} ]]; then color_code="${color_map[$color]}"; fi
   fi

   output="\033[${modifier_code};${color_code}m${message}\033[0m${linebreak}"

   # shellcheck disable=SC2059
   # echo "$output"
   printf "$output"
}
export -f prettyp

_prettyp_demo() {
   _c=0
   while ((_c < 128)); do
      echo "color: $_c"
      _m=0
      while ((_m < 128)); do
         if ((_m == 30)) || ((_m == 60)) || ((_m == 90)) || ((_m == 120));   then echo; fi
         prettyp "${_m}:${_c}" 'abc'
         # echo -n "${_m}:${_c}"
         echo -n ' '
         ((_m++))
      done
      echo
      ((_c++))
   done
}
