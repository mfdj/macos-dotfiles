
shush() {
   local proc=$1
   kill -9 "$(ps aux | grep "$proc" | grep -v grep | awk '{print $2}')"
}
