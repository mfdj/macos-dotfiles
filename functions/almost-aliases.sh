# shellcheck disable=SC2148

psg() {
   ps -ef | grep $1 | grep -v grep
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

vagrant() {
   vagrant-shim "$@"
}
export -f vagrant
