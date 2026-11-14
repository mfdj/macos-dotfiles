#!/usr/bin/env bash

bundle() {
   if (( $# > 0 )); then
      command bundle "$@"
   else
      { >&2 echo "adding --local"; }
      # https://bundler.io/v2.2/man/bundle-install.1.html
      # --local will attempt to skip rubygems.org and use Rubygems' cache or in vendor/cache
      command bundle install --local || bundle install
   fi
}

rake() {
   if [[ -f Gemfile ]]; then
      bundle exec rake "$@"
      return "$?"
   fi

   command rake "$@"
}

rails() {
   if [[ -f Gemfile ]]; then
      bundle exec rails "$@"
      return "$?"
   fi

   command rails "$@"
}

rspec() {
   if [[ -f Gemfile ]]; then
      bundle exec rspec "$@"
      return "$?"
   fi

   command rspec "$@"
}

rubocop() {
   if [[ -f Gemfile ]]; then
      bundle exec rubocop "$@"
      return "$?"
   fi

   command rubocop "$@"
}

