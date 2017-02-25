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

# preference precedence: ripgrep, egrep, grep
curlgrep() {
   local result
   result=/tmp/curl-grep-result

   if [[ $3 == last ]]; then
      (1>&2 echo "reusing $result-$1")
   else
      curl "$1" > "$result-$1"
      echo # clear last-line of curl's stderr
   fi

   if command -v rg &> /dev/null; then
      rg "$2" "$result-$1"

   elif command -v egrep &> /dev/null; then
      egrep "$2" "$result-$1"

   else
      grep "$2" "$result-$1"
   fi
}
