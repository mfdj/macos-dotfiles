#!/usr/bin/env bash

# keep in mind:
# - http://unix.stackexchange.com/questions/173916/is-it-better-to-use-pwd-or-pwd
# - http://unix.stackexchange.com/questions/79571/symbolic-link-recursion-what-makes-it-reset/79621#79621

cdp() {
   local use_color
   local alias_match

   CDP_ALIASES=${CDP_ALIASES:-~/.cdp_aliases}

   if [ -t 1 ]; then
      # not in-a-pipe or file-redireciton
      use_color=true
   fi

   if [[ $1 == "--init" || $1 == '-i' ]]; then
      if [[ -d $CDP_ALIASES ]]; then
         echo "'$CDP_ALIASES' pointing at a directory: you're golden"
      else
         mkdir -p "$CDP_ALIASES" && echo "created '$CDP_ALIASES'"
      fi

      return
   fi

   [[ -d $CDP_ALIASES ]] || {
      echo "CDP_ALIASES set '$CDP_ALIASES' which is not a directory. Run: cdp --init"
      return 1
   }

   if [[ $1 == "--path" || $1 == '-p' ]]; then
      if [[ -n $2 ]]; then
         export CDP_ALIASES=$2
      fi

      if [[ -d $CDP_ALIASES ]]; then
         echo "CDP_ALIASES set '$CDP_ALIASES' and valid"
      else
         echo "CDP_ALIASES set '$CDP_ALIASES' which is not a directory. Run: cdp --init"
         return 1
      fi
   fi

   if [[ $1 == '--add' || $1 == '-a' ]]; then
      local addpath=$PWD
      local aliasname
      [[ $addpath != "$CDP_ALIASES" ]] || return
      [[ -n $2 ]] && aliasname=$2 || aliasname=${addpath##*/};

      (
         cd "$CDP_ALIASES" || return 1
         rm "$aliasname" 2> /dev/null
         ln -s "$addpath" "$aliasname"
      )

      return
   fi

   if [[ $1 == '--remove' || $1 == '-r' ]]; then
      if [[ -n $2 ]]; then
         rm "$CDP_ALIASES/$2"
      else
         echo 'missing arugment for remove'
      fi

      return
   fi

   if (($# == 0)) || [[ $1 == '--list' ]] || [[ $1 == '-l' ]]; then
      for file in "$CDP_ALIASES"/*; do
         if [[ -h $file ]]; then
            if [[ -n $2 ]] && [[ ! $file =~ $2 ]]; then
               continue
            fi

            aliasname=$(basename "$file")
            symlink=$(readlink "$file")
            if [[ -n $use_color ]]; then
               echo -e " \033[1;35m${aliasname}\033[0m:${symlink}" | sed "s#$HOME#~#"
            else
               echo "${aliasname}:${symlink}" | sed "s#$HOME#~#"
            fi
         fi
      done | column -t -s ':'

      return
   fi

   if [[ $1 == '--prune' ]]; then
      echo "TODO: check for dead aliases, list 'em, and rm'em"
      return
   fi

   alias_match=$(find "$CDP_ALIASES" -iname "$1")

   [[ -n $alias_match ]] || alias_match=$(find "$CDP_ALIASES" -iname ".*$1.*")

   if [[ -n $alias_match ]]; then
      cd "$(readlink "$alias_match")" || return 1
   else
      echo "could not match '$1' to an alias"
      return 1
   fi
}
