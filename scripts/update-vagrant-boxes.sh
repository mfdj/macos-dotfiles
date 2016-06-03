#!/usr/bin/env bash

updateable=$(vagrant box outdated --global | grep outdated | tr -d "*'" | cut -d ' ' -f 2)

if [[ $updateable ]]; then
   for box in $updateable; do
      echo "Found an update for $box"

      versions=$(vagrant box list | grep $box | cut -d ',' -f 2 | tr -d ' )')

      vagrant box add --clean $box
      for version in $versions ; do
         vagrant box remove $box -f --box-version=$version
      done
   done
   echo 'All boxes are now up to date!'
else
   echo 'All boxes are already up to date!'
fi

vagrant box outdated --global
