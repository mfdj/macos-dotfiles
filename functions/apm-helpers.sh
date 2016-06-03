
apm_ensure() {
   for package in "$@"; do
      ls -l ~/.atom/packages | grep $package -q ||
         apm list | grep $package -q ||
         apm install $package
   done
}
