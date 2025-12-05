#!/usr/bin/env bash

_current_pr_stack=${_current_pr_stack:-''}

# TODO
# pr_stack <-- lists branches in the stack to switch to (should grey out current branch while leaving the index)
# pr_stack parent <-- print the parent branch
# pr_stack rebase <-- rebase all branches

#
#
#
pr_stack() {
   pr_stack::validate_stack

   if (( $# == 0 )); then
     pr_stack::change_branch
   fi

   if (( $# > 0 )); then
    case $1 in
      change*)
        shift
        pr_stack::change_branch "$@"
        return
      ;;

      parent)
        shift
        pr_stack::parent "$@"
        return
      ;;

      push)
        shift
        pr_stack::push "$@"
        return
      ;;

      rebase)
        shift
        pr_stack::rebase "$@"
        return
      ;;

      *)
        >&2 echo "Unknown command passed"
        return 1
      ;;
    esac
  fi
}

pr_stack::validate_stack() {
   if [[ -z $_current_pr_stack ]]; then
      prettyp 7:yellow '_current_pr_stack is empty'
      echo -n ' configure your stack with '
      prettyp break bold "_current_pr_stack='branch1
branch2
branch3'"
      return 1
   fi

   return 0
}

#
#
#
pr_stack::change_branch() {
   # local command=${1:-}

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
pr_stack::parent() {
   :
}

#
#
#
pr_stack::push() {
   local original_branch
   original_branch=$(git_current_branch)

   for branch in $_current_pr_stack; do
      git checkout "$branch"
      git push --force
   done

   git checkout "$original_branch"
}

#
#
#
pr_stack::rebase() {
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

         if [[ $interactive_flag ]]; then
            git rebase "$base_branch" "$interactive_flag"
         else
            git rebase "$base_branch"
         fi
      fi

      base_branch="$branch"
      (( index++ ))
   done

   git checkout "$original_branch"
}
