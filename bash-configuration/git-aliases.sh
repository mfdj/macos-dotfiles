#!/usr/bin/env bash

# + + + + + + + + + +
# +   git aliases   +
# + + + + + + + + + +

alias gitun='git reset HEAD~1'
alias ga='git add -A'
alias gf='git fetch --prune'
alias gfr='git fetch --prune && git reset --hard origin/$(git_current_branch)'
alias gcamend='git commit --amend --no-edit'
alias gcm='git commit -m'
alias gacm='git add -A . && git commit -am'
alias gch='git checkout'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
# shellcheck disable=SC2142
alias gsm="git status | grep modified | awk '{print \$2}'"
alias gdt='git difftool'
alias gmt='git mergetool'
alias gitrc='git rebase --continue'
alias gitrs='git rebase --skip'

# git mergetool (by default) can leave behind ".orig" after merges
# see: http://stackoverflow.com/questions/1251681/git-mergetool-generates-unwanted-orig-files
alias rmorig='rm ./**/*.orig'
