#!/usr/bin/env bash

# + + + + + + + + +
# +    aliases    +
# + + + + + + + + +

# general shell
alias crone='EDITOR=nano crontab -e'
alias grep='command grep --color'
alias sshp='ssh -o PubkeyAuthentication=no'

# NOTE: can't alias cd like this because avn chokes
#alias cd='cd -P' # follow symlinks https://unix.stackexchange.com/a/55715/29364

# ls
alias ll='ls -lF'
alias la='ls -laF'
alias lsg='ls -lF | grep -i --color'

# macos
alias showdot='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hidedot='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias blueoff='blueutil --power 0'
alias blueon='blueutil --power 1'

# php
alias c='composer'
alias cul='composer update --lock'
# NOTE: conventional pecl-installed extension path (homebrew-php does not use this path)
alias phpext="ls -l1 \$(php -i | grep ^extension_dir | sed 's/.* => //')"
alias phpini="php -i | grep 'php.ini.*=> ' | sed 's/.* => //'"

# GUI shortcuts
alias st='open -a SourceTree .'
alias md='open -a Macdown'
alias pstorm='open -a PhpStorm'
alias mine='open -a RubyMine'

# misc
alias speed='wget --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip'
alias wanip="curl -qs http://ifconfig.co"
alias dot='dotfiles'
