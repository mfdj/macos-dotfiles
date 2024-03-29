# shellcheck disable=SC2148

# + + + + + + + + + +
# +   git aliases   +
# + + + + + + + + + +

alias gitun='git reset HEAD~1'
alias ga='git add -A'
# fetch + prune
alias gf='git fetch --prune'
# fetch + prune and hard-reset to upstream
alias gfr='git fetch --prune && git reset --hard origin/$(git_current_branch)'
# gbg see: functions/git-helpers.sh
alias gcamend='git commit --amend --no-edit'
alias gcm='git commit -m'
alias gacm='git add -A . && git commit -am'
alias gch='git checkout'
# gchb see: functions/git-helpers.sh
alias gp='git push'
# gpu see: functions/git-helpers.sh
alias gpl='git pull'
alias gs='git status'
# shellcheck disable=SC2142
alias gsm="git status | grep modified | awk '{print \$2}'"
alias gdt='git difftool'
# gdf see: functions/git-helpers.sh
alias gmt='git mergetool'
alias grs='echo use gitrs;'
alias gitrc='git rebase --continue'
alias gitrs='git rebase --skip'
alias gsrm='git stash; git checkout master; git pull; git checkout -; git rebase master; git stash pop'
# gsrb see: functions/git-helpers.sh

# git mergetool (by default) can leave behind ".orig" after merges
# see: http://stackoverflow.com/questions/1251681/git-mergetool-generates-unwanted-orig-files
alias rmorig='rm ./**/*.orig'

# + + + + + + + + +
# +  deprecated   +
# + + + + + + + + +

alias gitl='echo use gl'
alias gits='echo use "gs"'
alias gitp='echo use "gp"'
alias gitpu='echo use "gpu"'
