# shellcheck disable=SC2148

# alias vagp='vagrant global-status --prune'

vagrant() {
   local has_vagrantfile
   local project_path
   local project_hash
   local ssh_config_path
   local vagrant_option_found
   local active_hosts
   local selected_host
   local is_tty

   _color_to_stderr() {
      local color
      color=$1
      shift

      # valid colors
      if [[ $color =~ (bold|green|yellow|grey|red) ]]; then
         [[ $color == bold   ]] && (>&2 echo -e "\033[1;1m${*}\033[0m")
         [[ $color == green  ]] && (>&2 echo -e "\033[1;32m${*}\033[0m")
         [[ $color == yellow ]] && (>&2 echo -e "\033[1;33m${*}\033[0m")
         [[ $color == grey   ]] && (>&2 echo -e "\033[37m${*}\033[0m")
         [[ $color == red    ]] && (>&2 echo -e "\033[1;91m${*}\033[0m")
         return 0
      fi

      # otherwise plain
      (>&2 echo "${*}")
      return 0
   }

   log() {
      _log error "use _log not log"
      _log "$@"
   }

   _log() {
      local level
      local color

      level=info
      [[ $1 =~ (debug|info|success|warn|error) ]] && {
         level=$1
         shift
      }

      color=plain # no-level
      [[ $level == debug   ]] && color=grey
      [[ $level == info    ]] && color=bold
      [[ $level == success ]] && color=green
      [[ $level == warn    ]] && color=yellow
      [[ $level == error   ]] && color=red

      if [[ $is_tty ]]; then
         _color_to_stderr plain "vagrant-shim [$level]: $*"

      elif [[ $DEBUG ]]; then
         _color_to_stderr "$color" "vagrant-shim: $*"

      elif [[ $level != debug ]]; then
         _color_to_stderr "$color" "$*"
      fi

      return 0
   }

   # ~=~=~=~~=~=~=~ basic-setup ~=~=~=~~=~=~=~

   # not in a pipe or file-redirection
   if [ ! -t 1 ] && [ ! -t 0 ]; then
      is_tty=true
   fi

   if [[ -f Vagrantfile ]]; then
      has_vagrantfile=true
      project_path=$(pwd)
      project_hash=$(md5 <<< "$(pwd)")
      ssh_config_path=/tmp/vagrant-${project_hash}-ssh-config

      _log debug "has_vagrantfile '$has_vagrantfile'"
      _log debug "project_path    '$project_path'"
      _log debug "project_hash    '$project_hash'"
      _log debug "ssh_config_path '$ssh_config_path'"
   fi

   # ~=~=~=~~=~=~=~ @extension: status ~=~=~=~~=~=~=~

   if [[ $1 == status ]]; then
      _log debug 'extending vagrant status'

      if [[ -z $has_vagrantfile ]]; then
         _log warn 'Vagrantfile missing, showing global-status'
         command vagrant global-status

         # preserves behavior for scripts that use exit code of `vagrant status`
         # to test if current directory has Vagrantfile
         return 1
      fi

      command vagrant status
      return $?
   fi

   # ~=~=~=~~=~=~=~ @extension: ssh ~=~=~=~~=~=~=~

   _check_sssh_config() {
      if command grep -q 'User vagrant' "$1"; then
         _log debug "'$1' looks like valid ssh-config"
         return 0
      else
         _log warn "'$1' does not look like valid ssh-config"
         return 1
      fi
   }

   _update_ssh_config() {
      if [[ -z $1 ]]; then
         _log warn 'update_ssh_config missing cache-path'
         return 1
      fi

      _log 'updating cached ssh-config'
      command vagrant ssh-config > "$1" 2> "$ssh_config_path-err"

      _log debug "vagrant ssh-config exited with: $?"

      while read line; do
         _log debug "ssh-config err: $line"
      done < "$ssh_config_path-err"

      _check_sssh_config "$1"
   }

   _ssh_shim() {
      local ssh_exit
      local retry_with_updated_config
      local ssh_err
      local ssh_out
      local inspect_line

      ssh_out=/tmp/vagrant-${project_hash}-ssh-stderr

      _log debug "ssh-shim options
  config   : '$1'
  host     : '$2'
  command  : '$3'
  err-file : '$ssh_err'"

      [[ $3 ]] && _log "running '$3' on '$2'" || _log "ssh'ing into '$2'"

      ssh -F "$1" "$2" "$3" 2> "$ssh_err"

      ssh_exit=$?
      (( $ssh_exit == 0 )) && _log debug "ssh first exit-code: $ssh_exit"
      (( $ssh_exit > 0  )) && _log warn  "ssh exited with non-zero status: $ssh_exit"

      [[ -s $ssh_err ]] && {
         _log debug "cat'ing stderr from ssh"
         (>&2 cat "$ssh_err")
      }

      (( $ssh_exit == 255 )) && [[ ! -s $ssh_err ]] && {
         _log debug 'ssh logged nothing to stderr, retrying verbosely'

         ssh -v -F "$1" "$2" "$3" 2> "$ssh_err"

         ssh_exit=$?
         _log debug "ssh-verbose exit-code: $ssh_exit"
      }

      retry_with_updated_config=''

      (( $ssh_exit == 255 )) && {
         inspect_line=$(tail -n1 "$ssh_err")
         _log debug "last line of stderr: $inspect_line"

         [[ $inspect_line =~ ssh.+Connection\ refused ]] && {
            _log info 'Connection refused: retrying with new ssh-config'
            retry_with_updated_config=true
         }
      }

      [[ $retry_with_updated_config ]] && {
         _log debug 'ssh retrying with updated config'

         _update_ssh_config "$1" && ssh -F "$1" "$2" "$3"
      }
   }

   if [[ $1 == ssh && $has_vagrantfile ]]; then
      _log debug 'extending vagrant ssh'

      vagrant_option_found=''

      for word in "${@:2}"; do
         _log debug "checking parameter '$word'"

         [[ $word =~ ^- ]] && {
            _log debug "shipping-ssh-shim becuase of '$word'"
            vagrant_option_found=true
         }
      done

      if [[ ! $vagrant_option_found ]]; then
         _log debug 'no vagrant-flags found, proceeding with ssh-shim'

         [[ -s $ssh_config_path ]] || _update_ssh_config "$ssh_config_path"

         if _check_sssh_config "$ssh_config_path"; then
            _log debug "trying ssh with '$ssh_config_path'"

            # check host against active-hosts
            active_hosts=$(grep -E '^Host .+' "$ssh_config_path" | awk '{print $2}')
            _log debug "active-hosts [$(tr '\n' ',' <<< "$active_hosts" | sed 's/,$//')]"

            # check if param-2 is active-host
            selected_host=$(grep -E "^${2}\$" <<< "$active_hosts")

            if [[ $selected_host ]]; then
               _log debug "using param-2 '$selected_host' as host"
               shift
            else
               _log debug "param-2: '$2' is not an active host"

               # select default (vagrant seems to default to the last box defined?)
               selected_host=$(tail -n1 <<< "$active_hosts")
               _log debug "using first active host '$selected_host'"
            fi

            _ssh_shim "$ssh_config_path" "$selected_host" "$2"
            return $?
         else
            _log error 'stopping ssh-shim because ssh-config is invalid'
            return 1
         fi
      fi
   fi

   # ~=~=~=~~=~=~=~ @extension: ssh-config ~=~=~=~~=~=~=~

   if [[ $1 == ssh-config && $has_vagrantfile ]]; then
      _log debug 'extending vagrant ssh-config'

      if _update_ssh_config "$ssh_config_path"; then
         cat "$ssh_config_path"
         return 0
      fi

      return 1
   fi

   # ~=~=~=~~=~=~=~ @new-command: ssh-config-file ~=~=~=~~=~=~=~

   if [[ $1 == ssh-config-file && $has_vagrantfile ]]; then
      _log debug "ssh-config-file echoing $ssh_config_path"
      echo "$ssh_config_path"
      return 0
   fi

   # ~=~=~=~~=~=~=~ vagrant fall through ~=~=~=~~=~=~=~

   _log debug "no commands to extend: passing '$*' to vagrant"

   command vagrant "$@"
}
