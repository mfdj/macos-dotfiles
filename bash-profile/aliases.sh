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
alias sf='[[ -f app/console ]] && app/console || bin/console'
# NOTE: conventional pecl-installed extension path (homebrew-php does not use this path)
alias phpext="ls -l1 \$(php -i | grep ^extension_dir | sed 's/.* => //')"
alias phpini="php -i | grep 'php.ini.*=> ' | sed 's/.* => //'"
alias mage='magento'
# magerun see: functions/almost-aliases

# vagrant + virtualbox
# vagrant see: commands/vagrant-shim
alias vagrant='vagrant-shim'
alias vg='vagrant'
alias vbox='VBoxManage'
alias vboxvms='VBoxManage list vms'
alias vboxrm='VBoxManage unregistervm'
alias vnight='VBoxManage list runningvms | cut -d" " -f1 | xargs -I X VBoxManage controlvm X poweroff'

# GUI shortcuts
alias st='open -a SourceTree .'
alias md='open -a Macdown'
alias pstorm='open -a PhpStorm'
alias mine='open -a RubyMine'

# misc
alias cofp='coffee --print'
# cofpr see: dynamic/aliases
alias speed='wget --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip'
alias wanip="curl -qs http://ifconfig.co"
alias dot='dotfiles'
