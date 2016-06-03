
require 'functions/append-source'

# + + + + + + + + + + + + + + + +
# +  dotfiles bootstrap files   +
# +  ~/.{bash_profile,bashrc}   +
# + + + + + + + + + + + + + + + +

# - bashrc should point at bash_profile

echo '• pointing .bashrc to .bash_profile'
echo '[[ -n $PS1 ]] && source ~/.bash_profile' > ~/.bashrc

# - clobber bash_profile so we can append to it

echo '• building .bash_profile'
echo "# bash_profile built: $(date '+%Y-%m-%d %T')" > ~/.bash_profile

# - append sources to bash_profile

# bind DOTFILES_DIR to this pacakge
echo "DOTFILES_DIR=$dotfiles_path" >> ~/.bash_profile

# ----------- STATIC --------------
#     (simply appends files)

# startup-cost: 0m0.025s
append_source  "$dotfiles_path/bash-profile" ~/.bash_profile

# startup-cost: 0m0.004s
append_source  "$dotfiles_path/functions"    ~/.bash_profile

# ----------- DYNAMIC --------------
# (exectue's each file as a script)

# NOTE: static elements sourced in this context so dynamic elements are aware of the current environment
source ~/.bash_profile
source "$dotfiles_path/local/bash-profile.sh"

# current startup-cost (with n) : 0m0.193s
# startup-cost with nvm         : 0m0.671s
append_source "$dotfiles_path/bash-profile/dynamic" ~/.bash_profile --exectue

# ----------- LOCAL-STATIC --------------
#     (append last for full control)

# startup-cost: 0m0.001s
append_source "$dotfiles_path/local/bash-profile.sh" ~/.bash_profile > /dev/null
