#!/usr/bin/env bash

search_itunes() {
   rg -i "$*" ~/Music/iTunes/iTunes\ Music\ Library.xml -A2
}

alias itunes_search='search_itunes'
