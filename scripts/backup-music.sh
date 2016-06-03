#!/usr/bin/env bash

original_args=$@
backup_target=$1
shift
[[ $1 == 'go' ]] && dry_run='' || dry_run='--dry-run'

[[ $backup_target ]] || {
   echo 'Need a backup-target'
   exit
}

if [[ -d $backup_target ]]; then
   backup_path=$backup_target
else
   echo "'$backup_target' is not a path, checking as a volume name"
   list=($(ls -l1 /Volumes | grep -i "$backup_target"))

   if [[ ${#list[@]} == 1 ]]; then
      echo "Found '/Volumes/$list'"
      backup_path=/Volumes/$list/iTunesLibraryBackup

      echo "Setting path to $backup_path"
      [[ -d $backup_path ]] || {
         echo 'Making backup path'
         mkdir -p $backup_path
      }
   elif [[ ${#list[@]} > 1 ]]; then
      echo "Too many matches ${list}"
      exit
   else
      echo "No matches"
      exit
   fi
fi

[[ -d $backup_path ]] || {
   echo 'backup path not resolved?'
   exit
}

[[ -d /Volumes/Music/iTunesLibrary ]] || {
   echo -e "\033[1;35mCheck that the Music drive is mounted\033[0m: '/Volumes/Music/iTunesLibrary' is not a directory"
   exit
}

[[ $dry_run ]] && {
   echo
   echo -e "\033[1;33mStarting dry-run\033[0m"
   echo
}

rsync_version=$(rsync --version | grep version | awk '{print $3}')

progress='--progress'
[[ $rsync_version && ${rsync_version:0:1} == 3 ]] && {
   progress='--info=progress2'
}

rsync --recursive --times --perms --links --safe-links \
   --human-readable --delete --exclude '.DS_Store' \
   $dry_run --stats $progress \
   /Volumes/Music/iTunesLibrary/* "$backup_path/"

[[ $dry_run ]] && {
   echo
   echo -e "\033[1;33mDry-run finsihed. To get wet run '$0 $original_args go'\033[0m"
   echo
}
