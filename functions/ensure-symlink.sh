# shellcheck disable=SC2148

ensure_symlink() {
   local src=${1%/}
   local dest=${2%/}
   local with_sudo=
   local current_src

   [[ ${3:-} == '--with-sudo' ]] && with_sudo=true

   # - if $dest is a symlink with incorrect source remove it
   # - if $dest is a file/folder back it up
   if [[ -h $dest ]]; then
      current_src=$(readlink $dest)
      [[ $src != "$current_src" ]] && {
         [[ ! $with_sudo ]] && rm "$dest"
         [[   $with_sudo ]] && sudo rm "$dest"
      }
   elif [[ -d $dest || -f $dest ]]; then
      [[ -e $dest-backup ]] && {
         [[ ! $with_sudo ]] && rm -rf "$dest-backup"
         [[   $with_sudo ]] && sudo rm -rf "$dest-backup"
      }
      echo "NOTICE: ensure_symlink backing-up '$dest' to '$dest-backup'"
      [[ ! $with_sudo ]] && mv "$dest" "$dest-backup"
      [[   $with_sudo ]] && sudo mv "$dest" "$dest-backup"
   fi

   # make that symlink!
   if [[ ! -h $dest ]]; then
      [[ ! $with_sudo ]] && ln -s "$src" "$dest"
      [[   $with_sudo ]] && sudo ln -s "$src" "$dest"
   fi
}
