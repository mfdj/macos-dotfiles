#!/usr/bin/env bash


now_utc() {
   date -u +%Y-%m-%dT%H:%M:%S
}
export -f now_utc
