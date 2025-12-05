#!/usr/bin/env bash

# aka: git log
gl() {
   # git --no-pager log --date=iso --pretty=format:"%h   %an   %aD   %s"
   # git --no-pager log --date=iso --pretty=format:"%h%x09%an%x09%ad%x09%s"
   if [[ -z "$1" ]]; then
      git --no-pager log --date=format:'%Y-%m-%d' --pretty=format:'%C(cyan)%h%Creset %C(bold)%ad%Creset%C(auto)%d %s'
   else
      git --no-pager log --date=format:'%Y-%m-%d' --pretty=format:'%C(cyan)%h%Creset %C(bold)%ad%Creset%C(auto)%d %s' -n "$1"
   fi
}

# aka: git log summary (for pull request)
gls() {
   if [[ -z "$1" ]]; then
      git --no-pager log --reverse --pretty=format:'%h %s'
   else
      git --no-pager log --reverse --pretty=format:'%h %s' -n "$1"
   fi
}

# aka: git-checkout-branch-plus-fuzzy-matching
gchb() {
   local branch selection branches remote

   branch=$1

   # special-meta-character
   if [[ $branch == '-' ]]; then
      git checkout -
      return 0
   fi

   # already a local-branch
   if git rev-parse --verify "$branch" &> /dev/null; then
      git checkout "$branch"
      return 0
   fi

   # start matching
   [[ $branch ]] && echo -e "\nbranches like '$branch':\n" \
                 || echo -e "\nall branches:\n"

   # $branches is a list of local and remote word-tuples:
   #   local, branch-path
   #   remote, remote-name, branch-path
   branch=${branch:-.*}
   branches=$({
      git branch | grep -i "$branch" | tr -d ' *' | awk '{print "local "$1}';
      git branch -r | grep -i "$branch" | tr -d ' *' | grep -v 'HEAD->' | awk '{
         at=index($1, "/"); remote=substr($1, 0, at - 1); branch=substr($1, at + 1); print "remote "remote" "branch
      }'
   })

   # display indexed table (start at 1)
   echo "$branches" | awk '{
      if ($1 == "local")
         print "\033[1m"$1"\033[0m \033[1;34m\033[40m "$2" \033[0m";
      else
         print $2" \033[37m\033[40m "$3" \033[0m";
   }' | nl -ba -s '. ' -w 4

   # could use column for alignment but has trouble when control characters are in the first column?
   # }' | column -s "~" -t | nl -ba -s '. ' -w 4

   # prompt user to select an index
   echo -en "\n select: "
   read -r selection
   echo

   # grab tuple by index; NOTE: validates selection
   selection=$(echo "$branches" | sed "${selection}q;d") || return 1

   # local-branches are easy
   if grep '^local ' -q <<< "$selection"; then
      branch=$(awk '{print $2}' <<< "$selection")
      git checkout "$branch"
      return 0
   fi

   # remotes are less easy
   remote=$(awk '{print $2}' <<< "$selection")
   branch=$(awk '{print $3}' <<< "$selection")

   git checkout -b "$branch" "$remote/$branch" || {
      echo -e "\033[1mprefixing branch with remote name: '$remote-$branch'\033[0m"
      if git rev-parse --verify "$remote-$branch" &> /dev/null; then
         git checkout "$remote-$branch"
         return 0
      fi
      git checkout -b "$remote-$branch" "$remote/$branch"
   }
}

# aka: git-push-upstream
gpu() {
   local remote local_name
   remote=${1:-origin}
   # shellcheck disable=SC2063
   local_name=$(git branch | grep '*' | tr -d '* ')

   # --no-verify will skip githooks, because the main point of this helper is to simply get the remote upstream set,
   # and to maybe start a draft PR: at this point I don't care about cleanliness checks
   git push --no-verify "$remote" --set-upstream "$local_name"
   remote_url=$(git remote -v | grep "$remote" | grep push | awk '{print $2}')
   if [[ $remote_url =~ git@github.com ]]; then
      github_repo=${remote_url#git@github.com:}
      github_repo=${github_repo%.git}
      open "https://github.com/${github_repo}/compare/${local_name}?expand=1"
   fi
}

# git branch with colorz
gb() {
   git branch
}

# aka: git-branch-grep
gbg() {
   local pattern=${1:-'.*'}
   { git branch; git branch -r; } | grep -i "$pattern"
}

gchr() {
   git checkout -b "rebased/$(git_current_branch)" && gsrb "$@"
}

# TODO: make safer
# aka: git-stash-rebase-from-branch
gsrb() {
   local rebase_from=$1
   local origin_branch
   local selection
   local stashed

   if git rev-parse --verify "$rebase_from" &> /dev/null; then
      echo -e "\nbranches '$rebase_from':\n"
      list=$(git branch -r | cut -f 2- -d / | grep -i "$rebase_from")
      echo "$list" | nl -ba -s '. ' -w 4
      echo -en "\n select: "
      read -r selection
      branch=$(echo "$list" | sed "${selection}q;d")
   fi

   if [[ -z $branch ]]; then
      return 1
   fi

   # git status uses "??" at the start of the line to indicate an untracked file
   if [[ $(git status --porcelain | grep -v '^??') != '' ]]; then
      stashed=1
      git stash
   fi

   if [[ $2 == fetch ]]; then
      git fetch --prune
   fi

   if git checkout "$rebase_from"; then
      origin_branch="origin/$(git_current_branch)"
      if git branch -r | grep "^  ${origin_branch}\$"; then
         git reset --hard "$origin_branch"
      else
         git pull
      fi
      git checkout -
      git --no-pager diff "$rebase_from" --stat
      echo -en "\n [enter to continue]"
      # shellcheck disable=SC2034
      read -r noop
      git rebase "$rebase_from"
   else
      return 1
   fi

   if [[ $stashed ]]; then
      git stash pop
   fi
}

# aka: git-diff-fancy
gdf() {
   if command -v diff-so-fancy > /dev/null; then
      git diff --color "$@" | diff-so-fancy
   else
      git diff --color "$@"
   fi
}

# aka git push stacked
gps() {
   local complete
   local current_branch
   local delay=''
   local depth
   local start_at
   local stack_size
   local wait_start
   local wait_duration=0
   local pr_checks_passed
   local countdown

   # Parse depth (start_at and stack_size)
   depth=${1:?'missing depth param'}
   shift

   if ! [[ $depth =~ ^[0-9]{1,2}-?[0-9]{0,2}$ ]]; then
      ( 1>&2 echo "Error: invalid depth, should be X-Y numeric but got '$depth'" )
      return 1
   fi

   start_at=${depth%-*}
   stack_size=${depth#*-}

   if (( start_at < 2 )) || (( start_at > 99 )); then
      ( 1>&2 echo "Error: invalid start_at, should be 2–99 but got '$start_at'" )
      return 1
   fi

   if (( stack_size < 1 )) || (( stack_size > 99 )); then
      ( 1>&2 echo "Error: invalid stack_size, should be 1–99 but got '$stack_size'" )
      return 1
   fi

   if (( stack_size > start_at )); then
      ( 1>&2 echo "(setting maximum stack_size to '$start_at')" )
      stack_size=$start_at
   fi

   if [[ $1 =~ [0-9]+ ]]; then
      delay=$1
      shift
   fi

   # Visualize parsed arguments
   1>&2 echo -n "Parsed start-at: $start_at stack-size: $stack_size"
   if [[ $delay ]]; then 1>&2 echo -n " delay: $delay"; fi
   if (( delay < 60 )) && (( stack_size > 1 )); then
      ( 1>&2 echo -n ' (setting minimum delay: 60 seconds)' )
      delay=60
   elif (( stack_size == 1 )) && [[ $delay ]]; then
      ( 1>&2 echo -n ' (delay will be unused because stack-size is 1)' )
   fi
   echo # line break

   # Display stack
   prettyp 7:green "Pushing following stack"
   if (( stack_size > 1 )); then prettyp 7:green " at $delay second interval"; fi
   if (( $# > 0 )); then
      prettyp 7:green " with these git push flags: $*"
   else
      prettyp 7:green ':'
   fi
   echo
   git log --abbrev-commit --max-count="$start_at" --format=oneline | tail -r -n "$stack_size"

   current_branch=$(git_current_branch)

   # check upstream
   maybe_github pr list --head "$current_branch"

   # Wait for confirmation
   echo
   prettyp 7:1 'Press any key to continue'
   # shellcheck disable=SC2034
   read -r noop

   # Work through the stack
   head_backdex=$(( start_at - 1 ))
   while [[ -z $complete ]]; do
      echo # empty line for visual organization

      git show "HEAD~$head_backdex" --oneline --no-patch
      echo git push origin "HEAD~$head_backdex:$current_branch" --force-with-lease "$@"
      git push origin "HEAD~$head_backdex:$current_branch" --force-with-lease "$@"

      pr_checks_passed=
      if github_pr_checks --watch; then
         pr_checks_passed=1
      fi

      stack_size=$(( stack_size - 1 ))
      if (( stack_size > 0 )); then
         head_backdex=$(( head_backdex - 1 ))
         echo "Wait for $delay seconds"
         wait_start=$(date +%s)
         wait_duration=0
         while [[ ! $pr_checks_passed ]] && (( wait_duration < delay )); do
            wait_duration="$(( $(date +%s) - wait_start ))"
            countdown=$(( delay - wait_duration ))
            echo -ne " ⏰ $countdown\033[0K\r"
            sleep 1
         done
      else
         complete=1
         echo
         echo "✨ Stack pushed ✨"
      fi
   done
}

git_current_branch() {
   git symbolic-ref HEAD 2> /dev/null | cut -c 12-
}

git_files_deleted_by() {
   local ref=$1
   local ref_show

   if ref_show=$(git show "$ref" 2>&1); then
      git show --no-color "$ref" | \
         grep 'deleted file' -A2 | \
         grep '\-\-\- a' | \
         awk '{print $2}' | \
         cut -c 3-
   else
      echo "$ref_show"
   fi
}

# gh/github specific

# if `gh` is available use it
maybe_github() {
   which -s gh && gh "$@"
}

#
#
#
github_pr_checks() {
   local gh_exit_code

   if ! which -s gh; then
      prettyp break yellow 'github_pr_checks: gh helper not available'
      return 127
   fi

   if gh pr checks "$@"; then
      prettyp break green 'github_pr_checks: exited with success'
      return 0
   else
      # Example 1 with --watch:
      # no checks reported on the 'mfdj/TPE-5780/spc-experiment-participation' branch
      # github_pr_checks: exited with failure (1)

      # Example 2 without --watch
      # (several in progress checks)
      # github_pr_checks: exited with failure (8)

      gh_exit_code=$?
      # white text on red
      prettyp break 37:41 "github_pr_checks: exited with failure ($gh_exit_code)"
      return "$gh_exit_code"
   fi
}
