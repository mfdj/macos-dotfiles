# shellcheck disable=SC2148

search_itunes() {
   grep -i "$@" ~/Music/iTunes/iTunes\ Music\ Library.xml
}

itunes_search() {
   search_itunes "$@"
}
