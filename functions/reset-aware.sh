#!/usr/bin/env bash

aware_reset() {
   ps -ef | grep -i Aware | grep -v grep | awk '{print $2}' | xargs -I{} kill {} && open -a 'Aware.app'
}

reset_aware() {
   aware-reset
}
