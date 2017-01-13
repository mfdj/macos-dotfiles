#!/usr/bin/env bash

if ((BASH_VERSINFO[0] >= 4)) && shopt globstar &> /dev/null; then
   echo alias cofpr=\'coffee --print './**/*.'coffee\'
else
   echo alias cofpr=\'echo globstar not available, only doing current directory\; cofp ./\*.coffee\'
fi

command -v subl > /dev/null || {
   if command -v atom > /dev/null; then
      echo alias subl=\'echo SublimeText is not installed, here is atom\; sleep 0.2\; atom\'
   else
      echo alias subl=\'echo SublimeText is not installed\'
   fi
}

command -v grc > /dev/null && {
   echo alias tree=\'grc tree\'
}
