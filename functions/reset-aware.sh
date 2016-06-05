# shellcheck disable=SC2148

aware-reset() {
   ps -ef | grep -i Aware | grep -v grep | awk '{print $2}' | xargs -I{} kill {} && open -a 'Aware.app'
}

reset-aware() {
   aware-reset
}
