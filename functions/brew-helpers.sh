
# install package if not found
brew_ensure() {
   local package=$1

   if ! ls -l1 "$(brew --prefix)/opt/" | grep $package -q; then
      (( $# != 1 )) && shift
      brew install "$@" && echo -n " ✔ $package"
   else
      echo -n " ✔ $package"
   fi
}

# install package if command not found
brew_ensure_command() {
   local cmd=$1

   if ! command -v $cmd > /dev/null; then
      (( $# != 1 )) && shift
      brew install "$@" && echo -n " ✔ $cmd"
   else
      echo -n " ✔ $cmd"
   fi
}

# TODO: try and make smarter?
cask_ensure() {
   brew cask install $1 2> /dev/null
   echo -n " ✔ $1"
}

# brew cask cleanup removes installers but not *installed* versions
# inspiration: https://github.com/troyxmccall/dotfiles/blob/8ab354f96f1184cbdd3574b3285a7afe89f2d9f3/.functions#L399-L422
# NOTE: use this only if you know for sure:
# - you don't need more than installed version of a cask!
# - a less recent cask-version has a more recent modification timestamp!
# - …?
cask_deep_clean() {
   local base='/opt/homebrew-cask/Caskroom' # NOTE: is this configurable? discoverable?
   local cask_versions
   local stale_versions
   local DO_CLEAN

   [[ $1 == go ]] && DO_CLEAN=true

   for cask in $(brew cask list); do
      cask_versions="$base/$cask"
      stale_versions="$(ls -r $cask_versions | sed 1,1d)"

      [[ $stale_versions ]] && {
         for stale in $stale_versions; do
            if [[ $DO_CLEAN ]]; then
               echo "Removing $cask $stale..."
               rm -rf "$cask_versions/$stale"
            else
               echo "Found stale: $cask $stale..."
            fi
         done
      }
   done
}
