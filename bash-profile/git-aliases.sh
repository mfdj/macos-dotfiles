
# + + + + + + + + + +
# +   git aliases   +
# + + + + + + + + + +

alias gitun='git reset HEAD~1'
alias ga='git add -A'
alias gb='git branch'
# gbg see: functions/git-helpers.sh
alias gcamend='git commit --amend --no-edit'
alias gcm='git commit -m'
alias gacm='git add -A . && git commit -am'
alias gch='git checkout'
# gchb see: functions/git-helpers.sh
#alias gl='git --no-pager log --date=iso --pretty=format:"%h%x09%an%x09%ad%x09%s" -n'
alias gl='git --no-pager log --date=iso --pretty=format:"%h   %an   %aD   %s" -n'
alias gp='git push'
# gpu see: functions/git-helpers.sh
alias gpl='git pull'
alias gs='git status'
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
