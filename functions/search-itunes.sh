# shellcheck disable=SC2148

search_itunes() {
   grep -i "$*" ~/Music/iTunes/iTunes\ Music\ Library.xml -A2
}

alias itunes_search='search_itunes'
