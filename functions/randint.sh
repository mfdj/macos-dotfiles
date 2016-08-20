# shellcheck disable=SC2148

randint() {
   local min max range bytes randRange randDecimal rangedInt
   
   min=$1
   max=$2

   [[ $max ]] || {
      max=$min
      min=0
   }

   range=$(( max - min ))
   bytes=4
   randRange=$(( 256 ** bytes ))

   if (( range > randRange )); then
      (>&2
         LC_NUMERIC=en_US printf "warning %'d is beyond randint's entropy resolution (0 - %'d)\n" $range $randRange
      )
   fi

   # problem with this approach is dd seems to split each bytes
   # local randDecimal=$(dd if=/dev/urandom bs=$bytes count=1 2> /dev/null | od -An -vtu1)

   # grab 4 bytes from /dev/urandom and convert binary to a decimal
   randDecimal=$(od -vAn -N4 -tu4 < /dev/urandom)

   # trim spaces and line-breaks from output of od (gotta be better way)
   randDecimal=$(echo $randDecimal | tr -d ' ' | tr -d "\n")

   # sane-looking mathematical expression piped to bc to execute the maths (-l for float precision)
   rangedInt=$(echo "$min + ($randDecimal / $randRange) * ($max - $min)" | bc -l)

   # prints a float with zero decimal places (i.e. floor)
   printf "%.0f" $rangedInt
}
