
curlh() {
   curl -s -D - $1 -o /dev/null
}

curlpjson() {
   # $1 = url
   # $2 = json
   curl "$1" \
      --request POST \
      --header 'Accept: application/json' --header 'Content-Type: application/json' \
      --data "$2" | grep } | python -mjson.tool
}
