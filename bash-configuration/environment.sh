# shellcheck disable=SC2148

# + + + + + + + + + + + + + + + + + + + +
# +  common across multiple machines    +
# + + + + + + + + + + + + + + + + + + + +

# dotfiles-commands
PATH=$PATH:${DOTFILES_DIR}/commands

# contextual bin folders
PATH=$PATH:./node_modules/.bin # npm
PATH=$PATH:./vendor/bin        # composer

# composer global packages
PATH=$PATH:~/.composer/vendor/bin

# NOTE: had tried adding `…$PATH:./bin` for rails projects but rbenv shims every
# gem across every version of ruby installed so this simple approach is not
# possible without moving rbenv's PATH decleration lower in precdence than ./bin
# which feels stupid/risky

# brew doctor recommends
PATH=/usr/local/bin:/usr/local/sbin:$PATH

# cdp function config
# shellcheck disable=SC2034
CDP_ALIASES=~/.cdp_aliases

# sets the title of the terminal-tab to $PWD with tilde-style home directory
PROMPT_COMMAND='printf "\e]1;%s\a" "$HOSTNAME: $PWD" | sed s#$HOME#~#'

# globstar, aka: **/*
if ((BASH_VERSINFO[0] >= 4)); then
   shopt -s globstar
else
   echo bash "${BASH_VERSINFO[0]}" does not support globstar
fi

# if editor is empty use nano; otherwise git, et al. default to vim
[[ $EDITOR ]] || export EDITOR=nano

# add grc aliases to path
if [[ -f /usr/local/etc/grc.bashrc ]]; then
   source /usr/local/etc/grc.bashrc
fi

# for custom bats-build of shellcheck
[[ -d ~/.cabal/bin ]] && PATH=${HOME}/.cabal/bin:${PATH}

# use bash-completion package if installed
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi

# + + + + +
# +  cd   +
# + + + + +

# change into directories without needing cd (NOTE: what are the implications for subshells)
shopt -s autocd

# fix basic typos when cd'ing
shopt -s cdspell

# `shopt -s dirspell` doesn't seem to do anything
