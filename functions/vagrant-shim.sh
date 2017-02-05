
# alias vagp='vagrant global-status --prune'

vagrant() {
   local has_vagrantfile
   local box_name
   local project_path
   local project_hash
   local ssh_config_path
   local vagrant_option_found
   local active_hosts
   local selected_host
   local ssh_config

   pipe_safe_color() {
      if [ -t 1 -a -t 0 ]; then
         # not in-a-pipe or file-redireciton
         if [[ $1 =~ (red|green|bold|yellow) ]]; then
            [[ $1 == red    ]] && echo -e "\033[1;91m${@:2}\033[0m"
            [[ $1 == green  ]] && echo -e "\033[1;32m${@:2}\033[0m"
            [[ $1 == yellow ]] && echo -e "\033[1;33m${@:2}\033[0m"
            [[ $1 == bold   ]] && echo -e "\033[1;1m${@:2}\033[0m"
            return 0
         fi
      fi

      (&>2 echo "${@}")
   }

   vglog() {
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

      return 0
   }

   # ~=~=~=~ basic-setup ~=~=~=~

   if [[ -f Vagrantfile ]]; then
      has_vagrantfile=true
      project_path=$(pwd)
      project_hash=$(md5 <<< "$(pwd)")
      ssh_config_path=/tmp/vagrant-ssh-config-${project_hash}

      vglog debug "has_vagrantfile  '$has_vagrantfile'"
      vglog debug "project_path     '$project_path'"
      vglog debug "project_hash     '$project_hash'"
      vglog debug "ssh_config_path '$ssh_config_path'"
   fi

   # ~=~=~=~ status-shim ~=~=~=~

   if [[ $1 == status ]]; then
      vglog debug 'shimming vagrant status'

      if [[ -z $has_vagrantfile ]]; then
         vglog warn 'Vagrantfile missing, showing global-status'
         command vagrant global-status

         # preserves behavior for scripts that use exit code of `vagrant status`
         # to test if current directory has Vagrantfile
         return 1
      fi

      command vagrant status
      return $?
   fi

   # ~=~=~=~ ssh-shim ~=~=~=~

   check_sssh_config() {
      if command grep -q 'User vagrant' "$1"; then
         vglog debug "'$1' looks like valid ssh-config"
         return 0
      else
         vglog warn "'$1' does not look like valid ssh-config"
         return 1
      fi
   }

   update_ssh_config() {
      if [[ -z $1 ]]; then
         vglog warn 'update_ssh_config missing cache-path'
         return 1
      fi

      vglog 'updating cached ssh-config'
      command vagrant ssh-config > "$1" 2> "$ssh_config_path-err"

      vglog debug "vagrant ssh-config exited with: $?"

      while read line; do
         vglog debug "ssh-config err: $line"
      done < "$ssh_config_path-err"

      check_sssh_config "$1"
   }

   ssh_shim() {
      local sshexit

      vglog debug "ssh_shim options - config: '$1' host: '$2' command: '$3'"
      vglog "ssh-shim running '$3' on '$2'"

      ssh -F "$1" "$2" "$3"
      # \
      #    1> /tmp/vagranth-ssh-${project_hash}-first \
      #    2> /tmp/vagranth-ssh-${project_hash}-first-err

      sshexit=$?
      vglog debug "ssh first exit-code: $sshexit"

      # cat /tmp/vagranth-ssh-${project_hash}-first-err
      # cat /tmp/vagranth-ssh-${project_hash}-first

      if (( $sshexit == 255 )); then
         vglog 'ssh-shim retrying'
         update_ssh_config "$1" && {
            vglog debug 'ssh-shim second attempt'
            ssh -F "$1" "$2" "$3"
         }
      fi
   }

   if [[ $1 == ssh && $has_vagrantfile ]]; then
      vglog debug 'shimming vagrant ssh'

      vagrant_option_found=''

      for word in "${@:2}"; do
         vglog debug "checking parameter '$word'"
         [[ $word =~ ^- ]] && {
            vglog debug "shipping-ssh-shim becuase of '$word'"
            vagrant_option_found=true
         }
      done

      if [[ ! $vagrant_option_found ]]; then
         vglog debug 'no vagrant-flags found, proceeding with ssh-shim'

         [[ -s $ssh_config_path ]] || update_ssh_config "$ssh_config_path"

         if check_sssh_config "$ssh_config_path"; then
            vglog debug "trying ssh with '$ssh_config_path'"

            # check host against active-hosts
            active_hosts=$(grep -E '^Host .+' "$ssh_config_path" | awk '{print $2}')
            vglog debug "active-hosts [$(tr '\n' ',' <<< "$hosts" | sed 's/,$//')]"

            # check if param-2 is active-host
            selected_host=$(grep -E "^${2}\$" <<< "$active_hosts")

            if [[ $selected_host ]]; then
               vglog debug "using '$selected_host'"
               shift
            else
               vglog debug "param-2: '$2' is not an active host"

               # select default
               selected_host=$(head -n1 <<< "$active_hosts")
               vglog debug "using first active host '$selected_host'"
            fi

            ssh_shim "$ssh_config_path" "$selected_host" "$2"
            return $?
         else
            vglog error "stopping ssh-shim because ssh-config is invalid"
            return 1
         fi
      fi
   fi

   if [[ $1 == ssh-config && $has_vagrantfile ]]; then
      vglog debug "ssh-config refreshing $ssh_config_path"

      if update_ssh_config "$ssh_config_path"; then
         cat "$ssh_config_path"
         return 0
      fi
      return 1
   fi

   if [[ $1 == ssh-config-file && $has_vagrantfile ]]; then
      vglog debug "ssh-config refreshing $ssh_config_path"
      echo "$ssh_config_path"
      return 0
   fi

   vglog debug "passing '$@' to vagrant"

   command vagrant "$@"
}
