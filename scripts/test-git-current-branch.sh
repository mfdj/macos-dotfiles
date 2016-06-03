#!/usr/bin/env bash

if ! command -v gdate > /dev/null; then
   echo "need gdate, install gnu-coreutils: brew install coreutils"
   exit 1
fi

# commands-to-profile
bash_subshell() {
   local ref=$(git symbolic-ref HEAD 2> /dev/null)
   echo "${ref##refs/heads/}"
}

bash_piped() {
   git symbolic-ref HEAD 2> /dev/null | { read ref; echo "${ref##refs/heads/}"; }
}

bash_seded() {
   git symbolic-ref HEAD 2> /dev/null | sed "s#refs/heads##"
}

bash_cut() {
   git symbolic-ref HEAD 2> /dev/null | cut -c 12-
}

# profiler
saturate() {
   echo "running: $@"
   local start=$(gdate +%s%3N)
   for n in {1..300}; do
      "$@" > /dev/null
   done
   stop=$(gdate +%s%3N)
   duration=$((stop - start))
   average=$(echo "scale=5; $duration / 300" | bc) # scale=5 means 5 decimal places
   echo " ${duration}ms total, ${average}ms average"
}

# setup test-context
echo "setup"
echo

rm -rf /tmp/test-git-current-branch 2> /dev/null
mkdir -p $_
cd $_
echo 'abc' > abc
git init
git add .
git commit -m 'init'
git checkout -b 'second'
git status

# run tests
echo
echo "test"
echo

# fastest
saturate vcprompt -f '%b'

# second
saturate bash_cut

# nearly-second
saturate bash_seded

# third
saturate bash_piped

# fourth
saturate bash_subshell
