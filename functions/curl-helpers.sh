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

# prefers ripgrep, falls back to then grep
curlgrep() {
   local url
   local pattern
   local resultPath
   local md5hash

   url=$1
   pattern=$2
   shift 2

   md5hash=$(md5 <<< "$url")
   resultPath=/tmp/curlgrep-result-${md5hash:0:12}

   if [[ $1 == last ]]; then
      (1>&2 echo "reusing $url (${resultPath})")
      shift

   else
      curl "$url" > "$resultPath"
      echo # clear last-line of curl's stderr
   fi

   # At this point remaining arguments are flags for grep/ripgrep
   # flags are not validated so the user must understand which
   # matching-engine is in use

   # matching-engine precedence: ripgrep, grep
   if command -v rg &> /dev/null; then
      rg "$pattern" "$resultPath" $*
   else
      grep -E "$pattern" "$resultPath" $*
   fi
}
