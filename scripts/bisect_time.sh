#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

pattern=${1:?'missing pattern param'}
current_commit=$(git rev-parse HEAD)
next_commit=$(git rev-parse "${2:?'missing next-commit param'}")

if [[ $current_commit == "$next_commit" ]]; then
   prettyp break red "current and next need to be different - both are: $next_commit"
   exit 1
fi

prettyp break italic:7 "bisect time for pattern: $pattern"

# Test current commit
prettyp break 2:2 "testing pattern in $current_commit"
if rg "$pattern"; then
   prettyp break blue "pattern detected in $current_commit: marking 'good'"
   current_action=good
else
   prettyp break yellow "pattern not detected in $current_commit: marking 'bad'"
   current_action=bad
fi

# Test next commit
git checkout "$next_commit"
prettyp break 2:2 "testing pattern in $next_commit"
if rg "$pattern"; then
   prettyp break blue "pattern detected in $next_commit: marking as 'good'"
   next_action=good
else
   prettyp break yellow "pattern not detected in $next_commit: marking 'bad'"
   next_action=bad
fi

# Ensure actions are complimentary
git checkout -
if [[ $current_action == "$next_action" ]]; then
   prettyp break bold:red "Incoherent bisect: curent and next action are both '$current_action'"
   exit 1
fi

prettyp break italic:7 "using $current_commit as $current_action and $next_commit as $next_action"

git bisect start
git bisect "$current_action" "$current_commit"
git bisect "$next_action" "$next_commit"
git bisect run rg "$pattern"
git bisect reset
