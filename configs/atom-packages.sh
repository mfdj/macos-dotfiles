#!/usr/bin/env bash

require 'functions/apm-helpers'

apm_ensure \
   atom-beautify \
   color-picker \
   docblockr \
   editorconfig \
   emmet \
   file-types \
   indent-guide-improved \
   language-apache \
   language-bats \
   language-gitignore \
   language-htaccess \
   language-json5 \
   linter \
   linter-shellcheck \
   pretty-json \
   seti-syntax \
   seti-ui

[[ $DO_OPTIONAL ]] && {
   apm_ensure \
      atom-handlebars \
      language-gherkin \
      language-haml
}
