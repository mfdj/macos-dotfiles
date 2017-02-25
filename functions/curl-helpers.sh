# shellcheck disable=SC2148

curlh() {
   curl -s -D - $1 -o /dev/null
}

curlpjson() {
   # $1 = url
   # $2 = json
   curl "$1" \
      --request POST \
      --header 'Accept: application/json' --header 'Content-Type: application/json' \
      --data "$2" | grep '}' | python -mjson.tool
}

# prefers ripgrep, falls back to egrep, then grep
curlgrep() {
   local url
   local pattern
   local result

   url=$1
   pattern=$2
   shift 2

   result=/tmp/curlgrep-result

   if [[ $1 == last ]]; then
      (1>&2 echo "reusing ${result}-${url}")
      shift

   else
      curl "$url" > "${result}-${url}"
      echo # clear last-line of curl's stderr
   fi

   # At this point remaining arguments are flags for grep/ripgrep
   # flags are not validated so the user must understand which
   # matching-engine is in use

   # matching-engine precedence: ripgrep, egrep, grep
   if command -v rg &> /dev/null; then
      rg "$pattern" "${result}-${url}" $*

   elif command -v egrep &> /dev/null; then
      egrep "$pattern" "${result}-${url}" $*

   else
      grep "$pattern" "${result}-${url}" $*
   fi
}
