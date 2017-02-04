
# alias vag='vagrant'
# alias vags='[[ -f Vagrantfile || -f vagrantfile  ]] && vagrant status || vagrant global-status'
# alias vbox='VBoxManage'
# alias vagp='vagrant global-status --prune'

vagrant() {
   local has_vagrantfile
   local box_name
   local project_path
   local project_hash
   local ssh_config_cache

   pipe_safe_color() {
      if [ -t 1 -a -t 0 ]; then
         # not in-a-pipe or file-redireciton
         if [[ $1 =~ (red|green|bold|yellow) ]]; then
            [[ $1 == red    ]] && echo -e "\033[1;91m${@:2}\033[0m"
            [[ $1 == green  ]] && echo -e "\033[1;32m${@:2}\033[0m"
            [[ $1 == yellow ]] && echo -e "\033[1;33m${@:2}\033[0m"
            [[ $1 == bold   ]] && echo -e "\033[1;1m${@:2}\033[0m"
            return
         fi
      fi

      echo "${@}"
   }

   log() {
      local color

      if [[ $1 == debug ]]; then
         [[ $DEBUG ]] && pipe_safe_color "vagrant-shim: ${@:2}"
      else
         color=bold # info is default
         [[ $1 == error   ]] && color=red
         [[ $1 == success ]] && color=green
         [[ $1 == warn    ]] && color=yellow
         [[ $1 =~ (error|success|info|warn) ]] && shift

         if [[ $DEBUG ]]; then
            pipe_safe_color "$color" "vagrant-shim: ${@}"
         else
            pipe_safe_color "$color" "${@}"
         fi
      fi
   }

   if [[ -f Vagrantfile ]]; then
      has_vagrantfile=true
      project_path=$(pwd)
      project_hash=$(md5 <<< "$(pwd)")
      ssh_config_cache=/tmp/vagrant-ssh-config-${project_hash}

      log debug "has_vagrantfile  '$has_vagrantfile'"
      log debug "project_path     '$project_path'"
      log debug "project_hash     '$project_hash'"
      log debug "ssh_config_cache '$ssh_config_cache'"
   fi

   # ~=~=~=~ status-shim ~=~=~=~

   if [[ $1 == status ]]; then
      if [[ -z $has_vagrantfile ]]; then
         log warn 'Vagrantfile missing, showing global-status'
         command vagrant global-status

         # preserves behavior for scripts that use exit code of `vagrant status`
         # to test if current directory has Vagrantfile
         return 1
      fi

      command vagrant status
      return $?
   fi

   # ~=~=~=~ ssh-shim ~=~=~=~

   update_ssh_config() {
      if [[ -z $1 ]]; then
         log warn 'update_ssh_config missing cache-path'
         return 1
      else
         log 'updating cached ssh-config'
         command vagrant ssh-config > "$1" || return 1
      fi

      if grep -q 'User vagrant' "$1" 2> /dev/null; then
         log debug "'$1' looks like valid ssh-config"
      else
         log debug "'$1' does not look like valid ssh-config"
         return 1
      fi
   }

   if [[ $1 == ssh && $has_vagrantfile ]]; then
      [[ -s "$ssh_config_cache" ]] || update_ssh_config "$ssh_config_cache"

      update_ssh_config '/tmp/asdf' || return 1

      if [[ -s "$ssh_config_cache" ]]; then
         log debug "trying ssh with '$ssh_config_cache'"

         return
      else
         log error "skipping ssh-shim because ssh_config_cache is empty"
      fi
   fi

   log debug "passing '$@' to vagrant"

   command vagrant "$@"
}
