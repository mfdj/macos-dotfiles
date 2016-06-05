# shellcheck disable=SC2148

randint() {
   local min=$1
   local max=$2

   [[ $max ]] || {
      max=$min
      min=0
   }

   local range=$(( max - min ))
   local bytes=4
   local randRange=$(( 256 ** bytes ))

   if (( range > randRange )); then
      (>&2
         LC_NUMERIC=en_US printf "warning %'d is beyond randint's entropy resolution (0 - %'d)\n" $range $randRange
      )
   fi

   # problem with this approach is dd seems to split each bytes
   # local randDecimal=$(dd if=/dev/urandom bs=$bytes count=1 2> /dev/null | od -An -vtu1)

   # grab 4 bytes from /dev/urandom and convert binary to a decimal
   local randDecimal=$(od -vAn -N4 -tu4 < /dev/urandom)

   # trim spaces and line-breaks from output of od (gotta be better way)
   randDecimal=$(echo $randDecimal | tr -d ' ' | tr -d "\n")

   # sane-looking mathematical expression piped to bc to execute the maths (-l for float precision)
   local rangedInt=$(echo "$min + ($randDecimal / $randRange) * ($max - $min)" | bc -l)

   # prints a float with zero decimal places (i.e. floor)
   printf "%.0f" $rangedInt
}
