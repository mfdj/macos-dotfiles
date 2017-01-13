# shellcheck disable=SC2148

# temporary shim to remind myself about gitrc for rebase workflows
grc() {
   if [[ -d .git && $(git status | grep rebase\ in\ progress) ]]; then
      echo use gitrc for git rebase --continue
   else
      command grc "$@"
   fi
}

psg() {
   ps -ef | grep $1 | grep -v grep
}

oh() {
   open http://"$1"
}

ohs() {
   open http://"$1"
}

breakon() {
   local sep=${2:- } # default to space
   echo "$1" | sed -e "s~${sep}~\\$(echo -e '\n\r')~g"
}

ipinfo() {
   curl "ipinfo.io/$1"
}

der2pem() {
   openssl x509 -inform der -outform pem -in $1 -out $1.pem
}
