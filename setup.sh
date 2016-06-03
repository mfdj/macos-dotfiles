#!/usr/bin/env bash

dotfiles_path="$(cd "$(dirname "$0")"; pwd -P)"

# parse configuration options
index=1
while [[ $index -le $# ]]; do
   word=${!index} && shift
   case $word in
    optional) do_optional=true;;
        cask) do_cask=true;;
      update) do_updates=true;;
       clean) do_clean=true;;
     q|quiet) do_quietly=true;;
        time) do_time=true;;
   esac
done

# log() {
#    local verbose
#    local quiet
#    local normal
#
#    while [[ $index -le $# ]]; do
#       word=${!index} && shift
#       case $word in
#        verbose) do_optional=true;;
#          quiet) do_cask=true;;
#       *|normal) do_updates=true;;
#       esac
#    done
# }

require() {
   source $dotfiles_path/$1.sh
}

run_module() {
   if [[ $do_quietly ]]; then
      source "$dotfiles_path/setup-modules/$1.sh" > /dev/null
   else
      echo -e "\n============ $1 ============"
      # log \
      #    verbose "\n============ $1 ============" \
      #    quiet "run: $1"

      if [[ $do_time ]]; then
         source "$dotfiles_path/setup-modules/$1.sh"
      else
         source "$dotfiles_path/setup-modules/$1.sh"
      fi
   fi
}

run_module packages-and-tools
[[ $do_languages ]] && run_module languages
run_module application-configuration
run_module osx-core
[[ $do_optional ]] && run_module osx-optional
run_module build-bash-profile

[[ $do_quietly ]] || {
   echo '============ Finished ============'
   echo
   echo Rebuilt ~/.bash_profile
}
