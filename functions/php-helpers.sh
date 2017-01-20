# shellcheck disable=SC2148

xdebugenable() {
   local phpfpm=$(brew services list | grep started | grep php | awk '{print $1}')
   local ini=$(php -i | grep xdebug.ini)
   local pattern='s~^;zend_extension~zend_extension~'
   [[ $1 == false ]] && pattern='s~^zend_extension~;zend_extension~'

   # BSD sed -i behavior
   sed -i .orig "$pattern" "$ini"
   rm "$ini.orig"

   [[ $phpfpm ]] && brew services restart "$phpfpm"
}

xdebugon() {
   xdebugenable
}

xdebugoff() {
   xdebugenable false
}
