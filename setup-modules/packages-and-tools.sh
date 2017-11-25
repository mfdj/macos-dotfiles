#!/usr/bin/env bash

require 'functions/ensure-symlink'

# + + + + + + + + + + + + + + + +
# +  XCode Command Line Tools   +
# + + + + + + + + + + + + + + + +

echo Ensuring XCode Command Line Tools
# if xcode has already installed it will evaluate to false
if xcode-select --install 2> /dev/null; then
   # is there is a way to check this w/o sudo?
   sudo xcodebuild -license 2> /dev/null
fi

# + + + + + + + + + + + + + + +
# +         Homebrew          +
# +  see configs/brew-files   +
# + + + + + + + + + + + + + + +

echo Ensuring Homebrew
[[ ! -f /usr/local/bin/brew ]] &&
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# ! command -v brew > /dev/null && {
#    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# }

brewfile() {
   rundot "brewfiles/$1"
   echo
}

[[ $DO_UPDATES ]] && brew update

# homebrew minimum
brewfile core

# homebrew optional
[[ $DO_OPTIONAL             ]] && brewfile optional
[[ $DO_CASK                 ]] && brewfile cask-core
[[ $DO_CASK && $DO_OPTIONAL ]] && brewfile cask-optional

# homebrew maintenance
# cask upgrade conversation: https://github.com/caskroom/homebrew-cask/issues/16033
[[ $DO_UPDATES ]] && brew upgrade
[[ $DO_CLEAN   ]] && { brew cleanup; brew cask cleanup; }

# + + + + + + + + + + + + + + + + + + + +
# + custom shellcheck with bats support +
# + + + + + + + + + + + + + + + + + + + +

_install_shellcheck_from_source() {
   cd ~/from-source/shellcheck && {
      git checkout bats &> /dev/null && {
         git pull &> /dev/null
         cabal update
         cabal install
      }
   }

   [[ -x ~/.cabal/bin/shellcheck ]] || {
      echo "Warning: failed to install shellcheck from source"
      require 'functions/brew-helpers'
      brew_ensure shellcheck
   }
}

if [[ ! -x ~/.cabal/bin/shellcheck ]]; then
   require 'functions/brew-helpers'
   brew_ensure cabal-install
   mkdir -p ~/from-source
   [[ -d ~/from-source/shellcheck ]] || git clone git@github.com:koalaman/shellcheck.git ~/from-source/shellcheck
   _install_shellcheck_from_source
elif [[ $DO_UPDATES ]]; then
   # Why are cabal reinstalls “always dangerous”?
   # https://stackoverflow.com/questions/19692644/why-are-cabal-reinstalls-always-dangerous
   _install_shellcheck_from_source
fi

# + + + + + + + + + + + + + + + +
# +         Composer            +
# +  getcomposer.org/download   +
# + + + + + + + + + + + + + + + +

# NOTE: Composer should install after Homebrew because /usr/local/ is created by Homebrew

echo Ensuring Composer
if [[ ! -f /usr/local/bin/composer ]]; then
   php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
   composerSHA384=$(curl https://getcomposer.org/download/ --silent | grep -i 'composer-setup.*\=\=\=' | sed 's/\(.*===\)//' | awk -F"'" '{print $2}')
   php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '${composerSHA384}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
   if [[ -f composer-setup.php ]]; then
      php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
      php -r "unlink('composer-setup.php');"
   else
      echo "composer-setup verification issue (sha384: ${composerSHA384}"
      echo 'check https://composer.github.io/pubkeys.html'
   fi
elif [[ $DO_UPDATES ]]; then
   composer selfupdate
else
   composer --version
fi

# + + + + + + + + + + + + + + + + + + +
# +  n (simple node version manager)  +
# +  github.com/tj/n                  +
# + + + + + + + + + + + + + + + + + + +

echo Ensuring N
if [[ ! -d ~/.n ]]; then
   git clone https://github.com/tj/n ~/.n
elif [[ $DO_UPDATES ]]; then
   { cd ~/.n && git pull; }
fi
