#!/usr/bin/env bash

echo 'line1-a line1-b
line2-a
line3-a line3-b line3-c' > /tmp/file-as-parameter-list

echo
echo cat /tmp/file-as-parameter-list
echo -~-~-~-~-
cat /tmp/file-as-parameter-list

echo
echo 'cat /tmp/file-as-parameter-list | xargs echo file:'
echo -~-~-~-~-
cat /tmp/file-as-parameter-list | xargs echo file:

# instead of piping cat (which would be useful for multiple files) redirect the file to STDIN
# (cuts down on a process too)
echo
echo '</tmp/file-as-parameter-list xargs echo file:'
echo -~-~-~-~-
</tmp/file-as-parameter-list xargs echo file: # xargs interperts line-breaks as a word seperator by default

echo
echo '</tmp/file-as-parameter-list xargs -I % echo line « % »'
echo -~-~-~-~-
</tmp/file-as-parameter-list xargs -I % echo line « % »

echo
echo '# create "my_echo" and export so sub-processes have access'
echo export -f 'my_echo'
echo 'my_echo() { echo "my_echoed: $@"; }'
my_echo() { echo "my_echoed: $*"; }
export -f 'my_echo'

echo
echo '# line-breaks and spaces create words'
echo "# trailing underscore ensures we don't lose the first word (why/how?)"
echo '<'/tmp/file-as-parameter-list xargs bash -c \'my_echo \$@\' _
echo -~-~-~-~-
</tmp/file-as-parameter-list xargs bash -c 'my_echo $@' _

echo
echo '# preserve lines'
echo '<'/tmp/file-as-parameter-list xargs -I % bash -c \'my_echo \$@\' _ %
echo -~-~-~-~-
</tmp/file-as-parameter-list xargs -I % bash -c 'my_echo $@' _ %
