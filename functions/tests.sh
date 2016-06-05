# shellcheck disable=SC2148

# Not sure about the implemenation value of these.
# Maybe they need a verbose mode and an exit code?

is_dir() {
   if [[ -d "$1" ]]; then echo "✔ $1"; else echo "missing: $1"; fi
}

is_command() {
   if   command -v $1 > /dev/null
   then echo "✔ $1"
   else echo "missing: $1"
   fi
}

is_function() {
   if   declare -f $1 > /dev/null
   then echo "✔ $1"
   else echo "missing: $1"
   fi
}
