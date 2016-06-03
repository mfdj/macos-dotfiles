# keep in mind:
# - http://unix.stackexchange.com/questions/173916/is-it-better-to-use-pwd-or-pwd
# - http://unix.stackexchange.com/questions/79571/symbolic-link-recursion-what-makes-it-reset/79621#79621

cdp() {
   CDP_ALIASES=${CDP_ALIASES:-~/.cdp_aliases}
   # path option
   # - print or set $CDP_ALIASES environment variable

   if [[ $1 == "--path" || $1 == '-p' ]]; then
      if [[ $2 ]]; then
         export CDP_ALIASES=$2
      elif [[ -d $CDP_ALIASES ]]; then
         echo "CDP_ALIASES set '$CDP_ALIASES' and valid"
      else
         echo "CDP_ALIASES set '$CDP_ALIASES' which is not a directory. Run: cdp --init"
      fi
      return
   fi

   # init option
   # - print or set $CDP_ALIASES environment variable

   if [[ $1 == "--init" || $1 == '-i' ]]; then
      if [[ -d $CDP_ALIASES ]]; then
         echo "'$CDP_ALIASES' pointing at a directory: you're golden"
      else
         mkdir -p $CDP_ALIASES && echo "created '$CDP_ALIASES'"
      fi
      return
   fi

   # if CDP_ALIASES is not a directory then bail
   [[ -d $CDP_ALIASES ]] || {
      echo "'$CDP_ALIASES' not pointing at a directory."
      return
   }

   # add option
   # - add the current-working-directory as a new alias
   # - under the hood creates a symlink under CDP_ALIASES

   if [[ $1 == '--add' || $1 == '-a' ]]; then
      local addpath=$PWD
      local aliasname
      [[ $addpath == $CDP_ALIASES ]] && return
      [[ $2 ]] && aliasname=$2 || aliasname=${addpath##*/}
      $(cd $CDP_ALIASES; rm $aliasname 2> /dev/null; ln -s "$addpath" $aliasname)

   # remove option
   # - remove the alias

   elif [[ $1 == '--remove' || $1 == '-r' ]]; then
      [[ $2 ]] \
         && rm $CDP_ALIASES/$2 \
         || echo 'missing arugment for remove'

   # list option
   # - list all aliases

   elif [[ $1 == "--list" || $1 == '-l' ]]; then
      (for file in $CDP_ALIASES/*; do
         if [[ -h $file ]]; then
            aliasname=$(basename $file)
            symlink=$(readlink $file)
            echo -e " \033[1;35m${aliasname}\033[0m:${symlink}" | sed "s#$HOME#~#"
         fi
      done) | column -t -s ':'

   # change to alias (when first agument isn't a valid flag)
   # - temporarily sets CDPATH variable (NOTE: not the same as CDP_ALIASES!)
   # - uses cd -P to resolve the alias

   else
      CDPATH=$CDP_ALIASES cd -P $1 > /dev/null
   fi
}
