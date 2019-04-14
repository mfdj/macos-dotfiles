#!/usr/bin/env bash

require 'functions/ensure-symlink'
require 'functions/path-helpers'

# + + + + + + + +
# +  readline   +
# + + + + + + + +

# NOTE: better to use .inputrc than use `bind "set …"` in bash-configuration/environment
# because it avoid issues when sourcing the intermediate build of .bashrc before
# running the dynamic bits
echo 'Ensuring readline .inputrc symlinked'
ensure_symlink \
   "$DOTFILES_DIR/configs/inputrc" \
   ~/.inputrc

# + + + + +
# +  Git  +
# + + + + +

# TODO: safe git-config like `git config --global core.excludesfile ~/.gitignore_global`
echo 'Ensuring global gitignore symlinked'
ensure_symlink \
   "$DOTFILES_DIR/configs/global-gitignore" \
   ~/.gitignore_global

git config --global core.editor nano

# + + + + + + + + + + + +
# +  Xcode Toolchains   +
# + + + + + + + + + + + +

# • not available via brew cask :-| (needs App Store)
# • I forget the package but once-upon-a-time a build script looked for …(clang? bison?) in this particlar path

[[ -d /Applications/Xcode.app ]] && {
   echo 'Ensuring Xcode Toolchains linked by version'
   toolchains=/Applications/Xcode.app/Contents/Developer/Toolchains

   if [[ -d ${toolchains}/XcodeDefault.xctoolchain ]]; then
      major_minor=$(sw_vers -productVersion | awk -F '.' '{print $1"."$2}')

      ensure_symlink \
         ${toolchains}/XcodeDefault.xctoolchain \
         ${toolchains}/OSX${major_minor}.xctoolchain \
         --with-sudo
   else
      echo "WARNING: expected to find ${toolchains}/XcodeDefault.xctoolchain"
   fi
}

# + + + + + + + + + + + + + + + + +
# +          MacDown              +
# +    a nice markdown editor     +
# +  github.com/uranusjr/macdown  +
# + + + + + + + + + + + + + + + + +

[[ -d ~/Library/Application\ Support/MacDown ]] && {
   echo 'Ensuring MacDown styles'
   ensure_symlink \
      $DOTFILES_DIR/configs/markdown-css \
      ~/Library/Application\ Support/MacDown/Styles
}

# + + + + + + + + + +
# +  Atom Packages  +
# +      apm        +
# + + + + + + + + + +

# TODO: figure out how to share common atom configs, cat ~/.atom/config.cson

command -v apm >/dev/null && {
   echo 'Ensuring Atom packages'
   rundot 'configs/atom-packages'
   [[ $DO_UPDATES ]] && apm update --confirm false # skips interactive confirmation
}

# + + + + + + + + + + +
# +  Sublime Text 3   +
# +    subl helper    +
# + + + + + + + + + + +

[[ -d /Applications/Sublime\ Text.app ]] && {
   echo 'Ensuring SublimeText subl command'
   ensure_symlink \
      /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl \
      /usr/local/bin/subl
}

# + + + + + + + + + + +
# +  PhpStorm Themes  +
# + + + + + + + + + + +

phpstorm_prefs=$(find ~/Library/Preferences | grep 'PhpStorm[0-9]*\.[0-9]*$')
[[ -d $phpstorm_prefs ]] && {
   echo 'Ensuring PhpStorm Templates'
   ensure_symlink $DOTFILES_DIR/configs/phpstorm-themes $phpstorm_prefs/colors
}

# + + + + + + + + + + +
# +   Kaleidoscope    +
# +  ksdiff helper    +
# + + + + + + + + + + +

[[ -d ~/Applications/Kaleidoscope.app && ! -f /usr/local/bin/ksdiff ]] && {
   echo 'Ensuring Kaleidoscope ksdiff command'
   ~/Applications/Kaleidoscope.app/Contents/MacOS/install_ksdiff
}

# + + + + + + + + + + +
# +  iTunes Scripts   +
# + + + + + + + + + + +

[[ -d $DOTFILES_DIR/local/iTunesScripts ]] && {
   echo 'Ensuring iTunesScripts are linked'
   ensure_symlink \
      $DOTFILES_DIR/local/iTunesScripts \
      ~/Library/iTunes/Scripts
}

# + + + + + + + + + + + +
# +   load grc aliases  +
# + + + + + + + + + + + +

command -v grc > /dev/null && {
   echo 'Ensuring grc configs are linked'
   ensure_symlink \
      $DOTFILES_DIR/configs/grc \
      ~/.grc
}

# + + + + + + + + + + + +
# +   vagrant plugins   +
# + + + + + + + + + + + +

command -v vagrant > /dev/null && {
   [[ $DO_OPTIONAL ]] && {
      echo 'Ensuring vagrant plugins are present'
      vagrant plugin install \
         vagrant-berkshelf \
         vagrant-cachier \
         vagrant-hostmanager \
         vagrant-omnibus \
         vagrant-share \
         vagrant-vbguest \
      > /dev/null
   }
}
