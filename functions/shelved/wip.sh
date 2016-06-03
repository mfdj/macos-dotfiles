
gbfl() {
   local GBCLBN=$1
   echo ""
   echo "$GBCLBN first & most recent commits:"
   git show --summary "$(git merge-base $GBCLBN master)" | grep Date
   git log --max-count=1 "$GBCLBN" -- | grep Date
}

fn_exists() {
   declare -f $1 > /dev/null
   return $?
}
