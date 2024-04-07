#!/usr/bin/env bash

clean_path() {
  [[ -d $1 ]] && rm -rf "$1"
  mkdir -p "$1"
}

ensure_path() {
  [[ ! -d $1 ]] && mkdir -p "$1"
}

# TODO: support symlinks
# TODO: verbose mode
# TODO: (maybe) ensure source and destination permissions are idenitcal for every part of the path
cp_path() {
   local dest src src_base

   if (( $# < 2 )); then
     echo 'need atleast two arguments (one or more sources followd by a dest)'
     return 1
   fi

   # find the last argument, which is the destination
   for dest in "$@"; do :; done;
   dest=${dest%/}

   # loop through all arguments
   for src in "$@"; do
      # remove trailing slashes
      src=${src%/}

      # avoid copying a dest into itself
      [[ $src == "$dest" ]] && continue

      # only deal with real directories or files
      [[ -d $src || -f $src ]] || {
         echo "source '$src' does not exist"
         continue
      }

      #echo "'$src' into '$dest' as '$dest/$src'"

      src_base=$(dirname $src)
      mkdir -p "$dest/$src_base" || continue
      rsync -a "$src" "$dest/$src_base"
   done
}
