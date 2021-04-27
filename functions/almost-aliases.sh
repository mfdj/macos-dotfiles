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

bundle() {
   if (( $# > 0 )); then
      command bundle "$@"
   else
      { >&2 echo "adding --local"; }
      # https://bundler.io/v2.2/man/bundle-install.1.html
      # --local will attempt to skip rubygems.org and use Rubygems' cache or in vendor/cache
      command bundle install --local || bundle install
   fi
}

vagrant() {
   vagrant-shim "$@"
}
export -f vagrant
