#!/usr/bin/env bash

if ((BASH_VERSINFO[0] >= 4)) && shopt globstar &> /dev/null; then
   echo alias cofpr=\'coffee --print './**/*.'coffee\'
else
   echo alias cofpr=\'echo globstar not available, only doing current directory\; cofp ./\*.coffee\'
fi
