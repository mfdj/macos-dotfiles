#!/usr/bin/env bash

require 'functions/apm-helpers'

apm_ensure \
   atom-beautify \
   docblockr \
   editorconfig \
   emmet \
   file-types \
   indent-guide-improved \
   language-gitignore \
   linter \
   linter-shellcheck \
   seti-syntax \
   seti-ui

[[ $DO_OPTIONAL ]] && {
   apm_ensure \
      atom-handlebars \
      color-picker \
      language-apache \
      language-bats \
      language-gherkin \
      language-htaccess \
      language-haml \
      language-json5 \
      pretty-json

   echo 'atom-package suggestions:
• nuclide - Hack IDE
'
}
