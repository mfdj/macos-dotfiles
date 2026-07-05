#!/usr/bin/env bash

days_from() {
   if [[ $# == 2 ]]; then
      php -r "echo (new DateTime('$1'))->diff(new DateTime('$2'))->format('%a');"
   else
      echo 'Expecting exactly 2 arguments'
   fi
}
