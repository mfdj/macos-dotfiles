
shush() {
   local proc matches match binary pid

   for proc in "$@"; do
      matches=$(ps aux | grep "$proc" | grep -v grep | sed -e 's/[[:space:]]\{2,\}/ /g')

      if [[ $matches ]]; then
         # pids=$(ps aux | grep "$proc" | grep -v grep | awk '{print $4}')
         echo "shushing process that match '$proc'"

         for match in $matches; do
            pid=$(echo "$match" | awk '{print $2}')
            binary=$(echo "$match" | cut -d ' ' -f 11-)
            echo "   pid '$pid' command '$binary'"
            kill -9 "$pid"
         done
      else
         echo "'$proc' already quiet!"
      fi
   done
}
