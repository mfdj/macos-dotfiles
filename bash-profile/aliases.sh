# shellcheck disable=SC2148

# + + + + + + + + +
# +    aliases    +
# + + + + + + + + +

# general shell
alias clearexit='cat /dev/null > ~/.bash_history && history -c && exit'
alias crone='EDITOR=nano crontab -e'
alias egrep='command egrep --color'
alias grep='command grep --color'
alias sshp='ssh -o PubkeyAuthentication=no'
alias lock='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# ls
alias ll='ls -lF'
alias la='ls -laF'
alias lsg='ls -lF | grep -i --color'

# macos
alias showdot='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hidedot='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias blueoff='blueutil power 0'
alias blueon='blueutil power 1'

# php
alias c='composer'
alias cul='composer update --lock'
alias sf='[[ -f app/console ]] && app/console || bin/console'
alias phpext="ls -l1 $(php -i | grep ^extension_dir | sed 's/.* => //')"
alias phpini="php -i | grep 'php.ini.*=> ' | sed 's/.* => //'"
alias mage='magento'
# magerun see: functions/almost-aliases

# vagrant + virtualbox
# vagrant see: functions/vagrant-shim
alias vg='vagrant'
alias vag='echo "deprecated: use vg"; vagrant'
alias vags='echo "deprecated: use vg status"; vagrant status'
alias vbox='VBoxManage'
alias vboxvms='VBoxManage list vms'
alias vboxrm='VBoxManage unregistervm'
alias vnight='VBoxManage list runningvms | cut -d" " -f1 | xargs -I X VBoxManage controlvm X poweroff'

# GUI shortcuts
alias st='open -a SourceTree .'
alias mou='open -a Mou'
alias md='open -a Macdown'
alias pstorm='open -a PhpStorm'

# misc
alias cofp='coffee --print'
# cofpr see: dynamic/aliases
alias speed='wget --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip'
alias wanip="curl -qs http://ifconfig.co"
alias dot='dotfiles'
