#!/usr/bin/env bash

# install package if not found
brew_ensure() {
   local package=$1

   if ! ls -l1 "$(brew --prefix)/opt/$package" &> /dev/null; then
      if (( $# != 1 )); then shift; fi
      brew install "$@" && echo -n " ✔ $package"
   else
      echo -n " ✔ $package"
   fi
}

# install package if command not found
brew_ensure_command() {
   local cmd=$1

   if ! command -v $cmd > /dev/null; then
      if (( $# != 1 )); then shift; fi
      brew install "$@" && echo -n " ✔ $cmd"
   else
      echo -n " ✔ $cmd"
   fi
}

# install cask package if not found
cask_ensure() {
   local package=$1

   if ! ls -l1 "$(brew --prefix)/Caskroom/$package" &> /dev/null; then
      brew install --cask "$package" && echo -n " ✔ $package"
   else
      echo -n " ✔ $package"
   fi
}

# install package if directory not found
cask_ensure_unless_directory() {
   local package=$1
   local dir=$2

   if [[ -d $dir ]]; then
      echo -n " ✔ $dir"
   else
      cask_ensure "$package"
   fi
}


# install brew and bootstrap it for shell
# supports both default prefixes (Intel and Apple Silicon)
ensure_brew_ready() {
   if ! command -v brew > /dev/null; then
      if [[ ! -f /opt/homebrew/bin/brew ]] && [[ ! -f /usr/local/bin/brew ]]; then
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      fi

      if [[ -f /opt/homebrew/bin/brew ]]; then # Apple Silicon
         eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -f /usr/local/bin/brew ]]; then # Intel
         eval "$(/usr/local/bin/brew shellenv)"
      else
         >&2 echo "Error: Failed to locate brew command"
         return 1
      fi
   fi
}
