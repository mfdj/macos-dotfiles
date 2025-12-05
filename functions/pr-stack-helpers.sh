#!/usr/bin/env bash

_current_pr_stack=${_current_pr_stack:-''}

#
#
#
pr_stack() {
   if [[ -z $_current_pr_stack ]]; then
      prettyp 7:yellow '_current_pr_stack is empty'
      echo -n ' configure your stack with '
      prettyp break bold "_current_pr_stack='branch1
branch2
branch3'"
      return
   fi

   # list stack in order
   echo "$_current_pr_stack" | awk '{
      print "\033[1;34m\033[40m "$1" \033[0m";
   }' | nl -ba -s '. ' -w 4

   # prompt user to select an index
   echo -en "\n select: "
   read -r selection
   echo

   branch=$(echo "$_current_pr_stack" | sed "${selection}q;d") || return 1
   git checkout "$branch"
}

#
#
#
pr_stack_rebase() {
   local original_branch
   local index=0
   local base_branch=
   local interactive_flag=

   if [[ $1 == main ]] || [[ $1 == master ]]; then
      base_branch=$1
      shift
   fi

   if [[ $1 == i ]] || [[ $1 == interactive ]]; then
      interactive_flag='-i'
      shift
   fi

   original_branch=$(git_current_branch)

   for branch in $_current_pr_stack; do
      git checkout "$branch" || return 1

      if [[ $base_branch ]]; then
         if [[ $interactive_flag ]]; then
            prettyp bold 'interactively '
         fi
         prettyp bold 'rebasing '
         prettyp 7:green "$branch"
         prettyp bold ' on 👉 '
         prettyp break 7:magenta  "$base_branch"
         if [[ $interactive_flag ]]; then
            echo
            prettyp 7:1 'Press any key to continue'
            # shellcheck disable=SC2034
            read -r noop
            echo
         fi
         git rebase "$base_branch" "$interactive_flag"
      fi

      base_branch="$branch"
      (( index++ ))
   done

   git checkout "$original_branch"
}

#
#
#
pr_stack_repush() {
   local original_branch
   original_branch=$(git_current_branch)

   for branch in $_current_pr_stack; do
      git checkout "$branch"
      git push --force
   done

   git checkout "$original_branch"
}
