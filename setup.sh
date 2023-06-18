#!/usr/bin/env bash

if [[ ${DOTFILES_DIR:-} ]] && [[ -f "$DOTFILES_DIR/setup-modules/_env.bash" ]]; then
   source "$DOTFILES_DIR/setup-modules/_env.bash"
elif [[ -f setup-modules/_env.bash ]]; then
   source setup-modules/_env.bash
else
   echo 'Error: could not source setup-modules/_env.bash'
   echo 'Tip: either set DOTFILES_DIR or run this script from that directory'
   exit 1
fi

export DO_OPTIONAL=
export DO_CASK=
export DO_UPDATES=
export DO_CLEAN=
export DO_QUIETLY=
export DO_TIME=

# parse configuration options
index=1
while [[ $index -le $# ]]; do
   word=${!index} && shift
   case $word in
    optional) DO_OPTIONAL=true;;
        cask) DO_CASK=true;;
      update|upgrade) DO_UPDATES=true;;
       clean) DO_CLEAN=true;;
     q|quiet) DO_QUIETLY=true;;
        time) DO_TIME=true;;
   esac
done

mkdir -p "$DOTFILES_DIR"/local/bin

rundot setup-modules/packages-and-tools
rundot setup-modules/application-configuration
rundot setup-modules/macos-core
if [[ ${DO_OPTIONAL:-} ]]; then
   rundot setup-modules/macos-optional
fi
rundot setup-modules/build-bash-configuration

[[ ${DO_QUIETLY:-} ]] || {
   echo
   echo '============ Finished ============'
   echo
   echo Rebuilt ~/.bashrc
   echo
}
