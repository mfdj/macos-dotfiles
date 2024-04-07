#!/usr/bin/env bash

shush() {
   local procName matches match binary pid

   for procName in "$@"; do
      matches=$(ps aux | grep -i "$procName" | grep -v grep | sed -E 's/[[:space:]]+/ /g')

      if [[ $matches ]]; then
         echo "shushing processes that match '$procName'"

         (
            # line-by-line instead of word-by-word
            IFS=$'\n'
            for match in $matches; do
               pid=$(echo "$match" | awk '{print $2}')
               binary=$(echo "$match" | cut -d ' ' -f 11-)

               # gaurd against over-shushing processes that quieted down when
               # one of their peers got shushed
               if ps aux | awk '{print $2}' | grep "$pid" > /dev/null; then
                  echo "   pid '$pid' command '${binary:0:128}'"
                  kill -9 "$pid"
               fi
            done
         )
      else
         echo "'$procName' already quiet!"
      fi
   done
}
