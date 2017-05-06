
lock() {
   local yn

   promptfor yn 'lock screen?'

   if is_yes yn; then
      /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
   fi
}
