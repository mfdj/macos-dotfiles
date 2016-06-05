#!/usr/bin/env bash

[[ $DOTFILES_DIR ]] || {
   echo "DOTFILES_DIR not set"; exit 1;
}

# shellcheck source=../functions/input-helpers.sh
source "$DOTFILES_DIR/functions/input-helpers.sh"

original_args=$*
backup_target=$1
[[ $2 == 'go' ]] && dry_run='' || dry_run='--dry-run'

[[ $backup_target ]] || {
   echo "No backup_target passed (argument 1 empty)"
   exit 1
}

default_bin=$(/usr/sbin/scutil --get ComputerName)-$(whoami)-backup

if [[ -d $backup_target ]]; then
   [[ $backup_target =~ /$ ]] && backup_target=${backup_target%?} # trim trailing slash
   backup_base=$backup_target
   echo -e "Current backup-base: \033[1;32m${backup_base}\033[0m"

   use_default_bin='yes'
   promptfor use_default_bin "Append \033[1m'$default_bin'\033[0m to backup-base?"
   if is_yes $use_default_bin; then
      backup_base=${backup_target}/${default_bin}
      echo -e "Updating backup-base: \033[1;32m${backup_base}\033[0m"
      [[ -d $backup_base ]] || {
         echo 'Making backup path'
         mkdir -p $backup_base
      }
   else
      echo -e "Using backup-base: \033[1;07m $backup_base \033[0m"
   fi
else
   echo "'$backup_target' is not a path, checking as a volume name"
   if [[ -d /Volumes/$backup_target ]]; then
      {
         cd "/Volumes/$backup_target" || exit 1
         # http://apple.stackexchange.com/a/240328/37418
         backup_base=$(/bin/pwd -P)/$default_bin
      }

      echo "Setting path to $backup_base"
      [[ -d $backup_base ]] || {
         echo 'Making backup path'
         mkdir -p $backup_base
      }
   else
      echo 'No matches'
      exit 1
   fi
fi

[[ -d $backup_base ]] || {
   echo "backup_base '$backup_base' did not resolve to a directory"
   exit
}

rsync_version=$(rsync --version | grep version | awk '{print $3}')

progress='--progress'
[[ $rsync_version ]] && (( ${rsync_version:0:1} > 2 )) && {
   progress='--info=progress2'
}

destination() {
   rsync_destination=$1
}

do_sync() {
   [[ ! $rsync_destination || $rsync_destination == '/' ]] && {
      echo
      echo -e "\033[7;91m rsync_destination is set to '$rsync_destination' which is invalid \033[0m \033[1;07m skipping \033[0m\033[1;35m $* \033[0m"
      return
   }

   for source in "$@"; do
      if [[ -d $source || -f $source ]]; then

         [[ -d $rsync_destination || $dry_run ]] || mkdir -p $rsync_destination

         echo
         echo -e "\033[1;34msyncing\033[0m \033[1;35m${source}\033[0m"
         echo -e "     \033[1;34mto\033[0m \033[1;32m${rsync_destination}\033[0m"

         rsync --recursive --links --perms --times --delete \
            $dry_run $progress --stats \
            --exclude '.vagrant' --exclude 'dump.rdb' --exclude '.DS_Store' \
            --exclude 'node_modules'  --exclude 'vendor' --exclude 'bower_components' \
            --exclude 'tmp' --exclude 'neo4j' --exclude '_local_only_' \
            "$source" "$rsync_destination"/
      else
         echo && echo -e "\033[1;07m skipping \033[0m\033[1;35m ${source} \033[0m"
      fi
   done
}

[[ $dry_run ]] && {
   echo
   echo -e "\033[1;33mStarting dry-run\033[0m"
   echo
}

## standard OSX
destination "$backup_base"
do_sync     ~/{Desktop,Documents,Downloads,Music,Pictures}

## personal
destination "$backup_base"
do_sync     ~/{.ssh,clients,FontExplorerX,projects}

## dotfiles-local
destination "$backup_base"/dotfiles-local
do_sync     ~/dotfiles/local/

## iBooks
destination "$backup_base"/LibraryContainers_iBooks
do_sync     ~/Library/Containers/com.apple.BKAgentService/Data/Documents/iBooks/

## iTunes device backups
destination "$backup_base"/LibraryAppSuport_DeviceBackups
do_sync     ~/Library/Application\ Support/MobileSync/Backup/

## 1Password
onepass_backups=$(find -E ~/Library -type d -iregex '.*(1|one)password.*/.*backups.*')
[[ $onepass_backups ]] && {
   destination "$backup_base"/1PasswordBackups
   do_sync $onepass_backups
}

## Knox
destination "$backup_base"
do_sync     ~/Library/StickiesDatabase

## stickies
destination "$backup_base"
do_sync     ~/Knox

## beaTunes
destination "$backup_base"/LibraryApplicationSupport_beaTunes
do_sync     ~/Library/Application\ Support/beaTunes/

## SublimeText
destination "$backup_base"/LibraryApplicationSupport_SublimeText3
do_sync     ~/Library/Application\ Support/Sublime\ Text\ 3/*Packages*

[[ $dry_run ]] && {
   echo
   echo -e "\033[1;33mDry-run finsihed. To get wet run '$0 $original_args go'\033[0m"
   echo
}
