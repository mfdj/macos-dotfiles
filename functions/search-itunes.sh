
search-itunes() {
   grep -i "$@" ~/Music/iTunes/iTunes\ Music\ Library.xml
}

itunes-search() {
   search-itunes "$@"
}
