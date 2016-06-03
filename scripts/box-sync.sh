#!/usr/bin/env bash

backup_dir=~/Box\ Sync/$(/usr/sbin/scutil --get ComputerName)-$(whoami)-archive
mkdir -p "$backup_dir"

rsync_version=$(rsync --version | grep version | awk '{print $3}')

progress='--progress'
[[ $rsync_version && ${rsync_version:0:1} > 2 ]] && {
   progress='--info=progress2'
}

do_sync () {
   rsync --recursive --perms --times --delete $progress --stats \
      --exclude '.svn' --exclude '.git' --exclude '.vagrant' --exclude 'dump.rdb'  \
      --exclude 'node_modules'  --exclude 'vendor' --exclude 'bower_components' \
      --exclude 'var' --exclude 'tmp' --exclude 'cache' --exclude 'neo4j' --exclude 'log' \
      --exclude '_local_only_' \
      "$1" "${backup_dir}"
}

do_sync ~/dotfiles
do_sync ~/projects
do_sync ~/Documents
