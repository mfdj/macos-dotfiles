#!/usr/bin/env bash

ensure_symlink() {
   local src=${1%/}
   local dest=${2%/}
   local with_sudo=
   local current_src

   if [[ ${3:-} == '--with-sudo' ]]; then
      with_sudo=true
   fi

   # - if $dest is a symlink with incorrect source remove it
   # - if $dest is a file/folder back it up
   if [[ -h $dest ]]; then
      current_src=$(readlink "$dest")
      if [[ $src != "$current_src" ]]; then
         if   [[ $with_sudo ]]
         then sudo rm "$dest"
         else rm "$dest"
         fi
      fi
   elif [[ -d $dest || -f $dest ]]; then
      if [[ -e $dest-backup ]]; then
         if   [[ $with_sudo ]]
         then sudo rm -rf "$dest-backup"
         else rm -rf "$dest-backup"
         fi
      fi

      echo "NOTICE: ensure_symlink backing-up '$dest' to '$dest-backup'"
      if   [[ $with_sudo ]]
      then sudo mv "$dest" "$dest-backup"
      else mv "$dest" "$dest-backup"
      fi
   fi

   # make that symlink!
   if [[ ! -h $dest ]]; then
      if   [[ $with_sudo ]]
      then sudo ln -s "$src" "$dest"
      else ln -s "$src" "$dest"
      fi
   fi
}
