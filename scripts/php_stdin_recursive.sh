#!/usr/bin/env bash

php <<'IN'
<?php
define('STDIN', fopen("php://stdin", "r"));
while (false !== ($line = fgets(STDIN))) {
   echo "Line: $line";
}
IN

# outputs 😏:
#
#   Line: define('STDIN', fopen("php://stdin", "r"));
#   Line: while (false !== ($line = fgets(STDIN))) {
#   Line:    echo "Line: $line";
#   Line: }
