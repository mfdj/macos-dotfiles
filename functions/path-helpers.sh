
clean_path() {
  [[ -d $1 ]] && rm -rf $1
  mkdir -p $1
}

ensure_path() {
  [[ ! -d $1 ]] && mkdir -p $1
}
