#!/usr/bin/env bash

apm_lazy_install() {
   for package in $@; do
      apm list | grep $package -q ||
         apm install $pacakge
   done
}

apm_lazier_install() {
   for package in $@; do
      ls -l ~/.atom/packages | grep $package -q ||
         apm list | grep $package -q ||
         apm install $package
   done
}

list='atom-beautify atom-handlebars editorconfig emmet file-types language-gherkin
      language-gitignore language-haml pretty-json seti-syntax seti-ui'

echo && echo lazy install && time apm_lazy_install $list

echo && echo lazier install && time apm_lazier_install $list

echo && echo 'normal install (re-installs all packages)' && time apm install $list
