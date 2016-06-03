#!/usr/bin/env bash

# git autocomplete
if brew --prefix git &> /dev/null; then
   git_prefix=$(brew --prefix git)
   echo source "${git_prefix}"/etc/bash_completion.d/git-completion.bash
fi

# None
NO_COLOR='\e[0m'
# Underlined
UBLACK='\e[4;30m'
# Bold (emphasized)
EBLACK='\e[1;30m'
ERED='\e[1;31m'
EWHITE='\e[1;37m'
# Normal
LGREY='\e[0;37m'
BLUE='\e[0;34m'
CYAN='\e[0;36m'
YELLOW='\e[0;33m'
MAGENTA='\e[0;35m'
RED='\e[0;31m'
BLACK='\e[0;30m'
WHITE='\e[0;37m'
# Background
BWHITE='\e[47m'

# vcprompt -f '%b'    70ms
# git_current_branch  110ms
if command -v vcprompt > /dev/null; then
   echo "PS1='\n\[$LGREY\]\h \[$YELLOW\]\u\[$NO_COLOR\] \[$MAGENTA\]\w \[$CYAN\]\$(vcprompt -f '%b')\[$NO_COLOR\] \n→ '"
elif command -v git_current_branch > /dev/null; then
   echo "PS1='\n\[$LGREY\]\h \[$YELLOW\]\u\[$NO_COLOR\] \[$MAGENTA\]\w \[$CYAN\]\$(git_current_branch)\[$NO_COLOR\] \n→ '"
else
   echo "PS1='\n\[$LGREY\]\h \[$YELLOW\]\u\[$NO_COLOR\] \[$MAGENTA\]\w\[$NO_COLOR\] \n→ '"
fi
