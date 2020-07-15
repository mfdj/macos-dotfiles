# shellcheck disable=SC2148

# aka: git-checkout-branch-plus-fuzzy-matching
gchb() {
   local branch selection branches remote

   branch=$1

   # special-meta-character
   [[ $branch == '-' ]] && {
      git checkout -
      return 0
   }

   # already a local-branch
   git rev-parse --verify "$branch" &> /dev/null && {
      git checkout "$branch"
      return 0
   }

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
      git rev-parse --verify "$remote-$branch" &> /dev/null && {
         git checkout "$remote-$branch"
         return 0
      }
      git checkout -b "$remote-$branch" "$remote/$branch"
   }
}

# aka: git-push-upstream
gpu() {
   local remote local_name
   remote=${1:-origin}
   # shellcheck disable=SC2063
   local_name=$(git branch | grep '*' | tr -d '* ')

   git push "$remote" --set-upstream "$local_name"
   remote_url=$(git remote -v | grep "$remote" | grep push | awk '{print $2}')
   [[ $remote_url =~ git@github.com ]] && {
      github_repo=${remote_url#git@github.com:}
      github_repo=${github_repo%.git}
      open "https://github.com/${github_repo}/compare/${local_name}?expand=1"
   }
}

# aka: git-branch-grep
gbg() {
   local pattern=${1:-'.*'}
   { git branch; git branch -r; } | grep -i "$pattern"
}

# aka: git-stash-rebase-from-branch
gsrb() {
   local branch=$1
   local origin_branch
   local selection
   local stashed

   git rev-parse --verify "$branch" &> /dev/null || {
      echo -e "\nbranches '$1':\n"
      [[ -z $branch ]] && branch='.*'
      list=$(git branch -r | cut -f 2- -d / | grep -i "$branch")
      echo "$list" | nl -ba -s '. ' -w 4
      echo -en "\n select: "
      read -r selection
      branch=$(echo "$list" | sed "${selection}q;d") || echo return
   }

   # git status uses "??" at the start of the line to indicate an untracked file
   if [[ $(git status --porcelain | grep -v '^??') != '' ]]; then
      stashed=1
      git stash
   fi

   git fetch
   git checkout "$branch" && {
      origin_branch="origin/$(git_current_branch)"
      if git branch -r | grep "^  ${origin_branch}\$"; then
         git reset --hard "$origin_branch"
      else
         git pull
      fi
      git checkout -
      git --no-pager diff "$branch" --stat
      echo -en "\n [enter to continue]"
      # shellcheck disable=SC2034
      read -r noop
      git rebase "$branch"
   }

   [[ $stashed ]] && git stash pop
}

# aka: git-diff-fancy
gdf() {
   if command -v diff-so-fancy > /dev/null; then
      git diff --color "$@" | diff-so-fancy
   else
      git diff --color "$@"
   fi
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
