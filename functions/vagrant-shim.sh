
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

   if [[ -f Vagrantfile ]]; then
      has_vagrantfile=true
      project_path=$(pwd)
      project_hash=$(md5 <<< "$(pwd)")
      ssh_config_cache=/tmp/vagrant-ssh-config-${project_hash}
   fi

   pipe_safe_color() {
      if [ -t 1 -a -t 0 ]; then
         # not in-a-pipe or file-redireciton
         if [[ $1 =~ (red|green|bold|yellow) ]]; then
            [[ $1 == red    ]] && echo -e "\033[1;91mvagrant-shim: ${@:2}\033[0m"
            [[ $1 == green  ]] && echo -e "\033[1;32mvagrant-shim: ${@:2}\033[0m"
            [[ $1 == yellow ]] && echo -e "\033[1;33mvagrant-shim: ${@:2}\033[0m"
            [[ $1 == bold   ]] && echo -e "\033[1;1mvagrant-shim: ${@:2}\033[0m"
            return
         fi
      fi

      echo "vagrant-shim: ${@}"
   }

   log() {
      local color

      if [[ $1 == debug ]]; then
         [[ $DEBUG ]] && pipe_safe_color "${@:2}"
      else
         color=bold # info is default
         [[ $1 == error   ]] && color=red
         [[ $1 == success ]] && color=green
         [[ $1 == warning ]] && color=yellow
         [[ $1 =~ (error|success|info|warning) ]] && shift

         pipe_safe_color "$color" "${@}"
      fi
   }

   if [[ $1 == status ]]; then
      if [[ -z $has_vagrantfile ]]; then
         log warning 'Vagrantfile missing, showing global-status'
         command vagrant global-status

         # preserves behavior for scripts that use exit code of `vagrant status`
         # to test if current directory has Vagrantfile
         return 1
      fi

      command vagrant status
      return $?
   fi

   command vagrant "$@"
}
