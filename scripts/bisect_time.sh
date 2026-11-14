#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

pattern=${1:?'missing pattern param'}
first_commit=$(git rev-parse HEAD)
next_commit=$(git rev-parse "${2:?'missing next-commit param'}")

prompt_continue() {
   printf "(press any key to continue)"
   read -r
   printf "\e[1A"
}

if [[ $first_commit == "$next_commit" ]]; then
   prettyp break red "current and next need to be different - both are: $next_commit"
   exit 1
fi

prettyp blue "Ready to test for pattern: "
prettyp bold:7 "$pattern"
prettyp break blue " ?"
prompt_continue

# Test current commit
prettyp break 2:2 "testing pattern in $first_commit (HEAD)"
if rg "$pattern"; then
   prettyp break blue "pattern detected in $first_commit: marking 'present'"
   first_action=present
else
   prettyp break yellow "pattern not detected in $first_commit: marking 'absent'"
   first_action=absent
fi

prettyp break blue "Is this the expected?"
prompt_continue
# Test next commit
git checkout "$next_commit"
prettyp break 2:2 "testing pattern in $next_commit"
if rg "$pattern"; then
   prettyp break blue "pattern detected in $next_commit: marking as 'present'"
   next_action=present
else
   prettyp break yellow "pattern not detected in $next_commit: marking 'absent'"
   next_action=absent
fi

# Ensure actions are complimentary
git checkout -
if [[ $first_action == "$next_action" ]]; then
   prettyp break bold:red "Incoherent bisect: curent and next action are both '$first_action'"
   exit 1
fi

# Bisect requires the 'old' commit to be an ancestor of the 'new' commit
if git merge-base --is-ancestor "$first_commit" "$next_commit"; then
   old_commit=$first_commit
   new_commit=$next_commit
   old_action=$first_action
elif git merge-base --is-ancestor "$next_commit" "$first_commit"; then
   old_commit=$next_commit
   new_commit=$first_commit
   old_action=$next_action
else
   prettyp break bold:red "Incoherent bisect: $first_commit and $next_commit are on divergent branches (neither is an ancestor of the other)"
   exit 1
fi

trap 'git bisect reset' EXIT

if [[ $old_action == present ]]; then
   prettyp break italic:7 "searching for the commit that removed the pattern ($old_commit..$new_commit)"
   git bisect start --term-old=present --term-new=absent "$new_commit" "$old_commit"
   git bisect run rg "$pattern"
else
   prettyp break italic:7 "searching for the commit that introduced the pattern ($old_commit..$new_commit)"
   git bisect start --term-old=absent --term-new=present "$new_commit" "$old_commit"
   git bisect run sh -c '! rg "$1"' _ "$pattern"
fi

