
# + + + + + + + + +
# +    aliases    +
# + + + + + + + + +

# general shell
alias clearexit='cat /dev/null > ~/.bash_history && history -c && exit'
alias crone='EDITOR=nano crontab -e'
alias grep='command grep --color'
alias sshp='ssh -o PubkeyAuthentication=no'

# ls
alias ll='ls -lF'
alias la='ls -laF'
alias lsg='ls -lF | grep --color'

# macos
alias showdot='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hidedot='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias blueoff='blueutil power 0'
alias blueon='blueutil power 1'

# php
alias c='composer'
alias cr='composer require'
alias cul='composer update --lock'
alias sf='[[ -f app/console ]] && app/console || bin/console'
alias phpext="ls -l1 $(php -i | grep ^extension_dir | sed 's/.* => //')"
alias phpini="php -i | grep 'php.ini.*=> ' | sed 's/.* => //'"
alias mage='magento'
alias magerun='n98-magerun2'

# vagrant + virtualbox
alias vag='vagrant'
alias vags='[[ -f Vagrantfile || -f vagrantfile  ]] && vagrant status || vagrant global-status'
alias vagp='vagrant global-status --prune'
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
# cofpr see: dynamic/aliases.sh
alias speed='wget --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip'
alias wanip="curl -qs http://ifconfig.co"
alias dot='dotfiles'

# + + + + + + + + +
# +  deprecated   +
# + + + + + + + + +

#alias ccp='composer create-project --prefer-dist --profile'
## php + pdo_mysql and pcntl extensions (and timezone) -- for symfony2
#alias php_pcntl='php -d extension=pcntl.so'
#alias phps='open http://localhost:8888 && php -S localhost:8888/'
#alias sf='php app/console'
#alias sfstart='php_pcntl app/console server:start'
#alias sfstop='php_pcntl app/console server:stop'
#alias sfr='php app/console router:debug --env=prod'
#alias sfc='php app/console cache:clear --env=prod; php app/console cache:clear --env=dev'
#alias sfix='php app/console d:d:d --force && php app/console d:d:c && php app/console d:fix:l --no-interaction'
#alias sfixmig='sf d:d:d --force; sf d:d:c; sf d:m:m --no-interaction && sf d:fix:l --no-interaction'
#alias blackfire_agent_check='launchctl list | grep blackfire -q && echo available || echo not available'
#alias blackfire_agent_toggle='launchctl list | grep blackfire -q && launchctl unload $_BLACKFIRE_AGENT || launchctl load -w $_BLACKFIRE_AGENT'
