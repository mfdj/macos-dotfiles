
uhistory() {
   if [[ $1 ]]; then
      history | grep -v history | tail -n "$1" | cut -d " " -f 5- | sort | uniq
   else
      history | grep -v history | cut -d " " -f 5- | sort | uniq
   fi
}
