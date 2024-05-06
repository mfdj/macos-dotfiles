#!/usr/bin/env bash

# + + + + + + + + + + + + + + + + + + + +
# +  common across multiple machines    +
# + + + + + + + + + + + + + + + + + + + +

# dotfiles-commands
PATH=$PATH:${DOTFILES_DIR}/commands

PATH=$PATH:${DOTFILES_DIR}/local/bin/

# contextual bin folders
PATH=$PATH:./node_modules/.bin # npm
PATH=$PATH:./vendor/bin        # composer

# composer global packages
PATH=$PATH:~/.composer/vendor/bin

# NOTE: had tried adding `…$PATH:./bin` for rails projects but rbenv shims every
# gem across every version of ruby installed so this simple approach is not
# possible without moving rbenv's PATH decleration lower in precdence than ./bin
# which feels stupid/risky

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

# ensure EDITOR fallsback to nano; otherwise git, et al. default to vim
export EDITOR=${EDITOR:-nano}

# add grc aliases to path

# if [[ -f "$(brew --prefix)/etc/grc.sh" ]]; then
#    source "$(brew --prefix)/etc/grc.sh"
# fi

# + + + + +
# +  cd   +
# + + + + +

# change into directories without needing cd (NOTE: what are the implications for subshells)
if ((BASH_VERSINFO[0] >= 4)); then
   shopt -s autocd
else
   echo bash "${BASH_VERSINFO[0]}" does not support autocd
fi

# fix basic typos when cd'ing
shopt -s cdspell

# `shopt -s dirspell` doesn't seem to do anything

# + + + + + + +
# +  history  +
# + + + + + + +

# https://mrzool.cc/writing/sensible-bash/
# see also:
# • https://unix.stackexchange.com/questions/145250/where-is-bashs-history-stored
# • https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history

# When closing a session append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Appened each line to history file after it's issued: new sessions will read the history file but concurrent sessions won't see each others commands
PROMPT_COMMAND="$PROMPT_COMMAND; history -a"

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# • ignoredups - ignore duplicate commands; when used w/o erasedups will just ignore duplicates which immediately precede each other
# • erasedups - remove the last duplicate entry; only works if ignoredups is present; won't retroactively de-deupe the entire history, just the most recent duplicate
# • ignorespace - ignore commands which start with a space
# NOTE: "ignoreboth" is equivalent to "ignoredups:ignorespace" but I dislike the semantic ambiguity
HISTCONTROL="ignoredups:erasedups:ignorespace"

# Don't record some commands (colon seperated list)
export HISTIGNORE="history"

# Add a timestamp to each history item
HISTTIMEFORMAT='%F %T '
