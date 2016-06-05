apm_ensure \
   atom-beautify \
   editorconfig \
   emmet \
   file-types \
   indent-guide-improved \
   language-gitignore \
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
