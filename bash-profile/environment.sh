
# + + + + + + + + + + + + + + + + + + + +
# +  common across multiple machines    +
# + + + + + + + + + + + + + + + + + + + +

# dotfiles-commands
export PATH=$PATH:$DOTFILES_DIR/commands

# contextual bin folders
export PATH=$PATH:./node_modules/.bin # npm
export PATH=$PATH:./vendor/bin        # composer

# composer global packages
export PATH=$PATH:~/.composer/vendor/bin

# NOTE: had tried adding `…$PATH:./bin` for rails projects but rbenv shims every
# gem across every version of ruby installed so this simple approach is not
# possible without moving rbenv's PATH decleration lower in precdence than ./bin
# which feels stupid/risky

# brew doctor recommends
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# cdp function config
export CDP_ALIASES=~/.cdp_aliases

# sets the title of the terminal-tab to $PWD with tilde-style home directory
PROMPT_COMMAND='printf "\e]1;%s\a" "$HOSTNAME: $PWD" | sed s#$HOME#~#'

# globstar, aka: **/*
if ((BASH_VERSINFO[0] >= 4)); then
   shopt -s globstar
else
   echo bash $BASH_VERSINFO does not support globstar
fi

# ensure default editor is not empty; otherwise git defaults to vim, et al.
[[ $EDITOR ]] || export EDITOR=nano

# phpbrew
#source /Users/markfox/.phpbrew/bashrc

# add grc aliases to path
if [[ -f /usr/local/etc/grc.bashrc ]]; then
   source /usr/local/etc/grc.bashrc
fi
