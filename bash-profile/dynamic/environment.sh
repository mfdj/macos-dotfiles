#!/usr/bin/env bash

# git autocomplete
if brew --prefix git &> /dev/null; then
   git_prefix=$(brew --prefix git)
   echo source "${git_prefix}"/etc/bash_completion.d/git-completion.bash
fi

## None
NO_COLOR='\e[0m'

## Underlined
#UBLACK='\e[4;30m'

## Bold (emphasized)
#EBLACK='\e[1;30m'
ERED='\e[1;31m'
#EWHITE='\e[1;37m'

## Normal
LGREY='\e[0;37m'
#BLUE='\e[0;34m'
CYAN='\e[0;36m'
YELLOW='\e[0;33m'
MAGENTA='\e[0;35m'
#RED='\e[0;31m'
#BLACK='\e[0;30m'
#WHITE='\e[0;37m'

## Background
#BWHITE='\e[47m'

## NOTE: pre-compiling colors which probably isn't saving much CPU-time but demonstrates
## robust mix of pre-compilied values and later-to-be interpreted syntax.

echo "USER_COLOR='$YELLOW'
if [[ \$UID == '0' || \$USER == 'root' ]]; then
   USER_COLOR='$ERED'
fi"

## time vcprompt -f '%b'   --> 70ms
## time git_current_branch --> 110ms

if command -v vcprompt > /dev/null; then
   echo "PS1='\n\[$LGREY\]\h \['"'"'\$USER_COLOR'"'"'\]\u\[$NO_COLOR\] \[$MAGENTA\]\w \[$CYAN\]\$(vcprompt -f '%b')\[$NO_COLOR\] \n→ '"

elif command -v git_current_branch > /dev/null; then
   echo "PS1='\n\[$LGREY\]\h \['"'"'\$USER_COLOR'"'"'\]\u\[$NO_COLOR\] \[$MAGENTA\]\w \[$CYAN\]\$(git_current_branch)\[$NO_COLOR\] \n→ '"

else
   echo 'PS1="'"\n\[$LGREY\]\h \[\${USER_COLOR}\]\u\[$NO_COLOR\] \[$MAGENTA\]\w\[$NO_COLOR\] \n→ "'"'
fi

## sample output:
#
#    USER_COLOR='\e[0;33m'
#    if [[ $UID == '0' || $USER == 'root' ]]; then
#      USER_COLOR='\e[1;31m'
#    fi
#
#    PS1='\n\[\e[0;37m\]\h \['"$USER_COLOR"'\]\u\[\e[0m\] \[\e[0;35m\]\w \[\e[0;36m\]$(vcprompt -f '%b')\[\e[0m\] \n→ '
#
