#!/usr/bin/env bash

npm_init() {
   [[ -f package.json  ]] || echo "{\"name\": \"${PWD##*/}\", \"private\": true}" > package.json
   [[ -f .editorconfig ]] || cp "$DOTFILES_DIR/configs/my-prefs.editorconfig" .editorconfig
}

npminit() {
   npm_init
}
