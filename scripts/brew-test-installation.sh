
# fastest (2 + 2 on average)
ls_brew_prefix_memoization() {
   homebrew_prefix=${homebrew_prefix:-$(brew --prefix)} # runs once per shell session
   ls -l1 $homebrew_prefix/opt/ | grep $1 -q && echo "$1 installed by brew" || echo "$1 not-brewed"
}

# still really fast (8 + 8 on average)
ls_brew_prefix() {
   ls -l1 "$(brew --prefix)/opt/" | grep $1 -q && echo "$1 installed by brew" || echo "$1 not-brewed"
}

# faster for already installed (151 + 160 ms on average)
brew_ls_with_package() {
   brew ls "$1" &> /dev/null && echo "$1 installed by brew" || echo "$1 not-brewed"
}

# second (157 + 154 ms on average)
brew_ls_piped_grep() {
   brew ls -1 | grep "$1" -q && echo "$1 installed by brew" || echo "$1 not-brewed"
}

# third (184 + 155 ms on average)
brew_prefix() {
   if brew --prefix $1 2> /dev/null | grep /usr/local/opt/$1 -q; then
      echo "$1 installed by brew"
   else
      echo "$1 not-brewed"
   fi
}

# slowest (277 + 2428 ms on average)
brew_install() {
   brew install $1 &> /dev/null && echo "$1 installed by brew" || echo "$1 not-brewed"
}

saturate() {
   start=$(gdate +%s%3N)
   for n in {1..50}; do
      $1 $2 > /dev/null
   done
   stop=$(gdate +%s%3N)
   duration=$((stop - start))
   average=$((duration / 50))
   echo " $duration total, $average average"
}

# wget + gdate (coreutils) are installed
brew install wget coreutils &> /dev/null

echo
echo 50 itterations
echo first with "wget", a real, already installed pacakge
echo second with "not-a-pacakage", a package that does not exsist and cannot be installed

echo && echo '~~~~~~~~ ls_brew_prefix_memoization ~~~~~~~~'
saturate ls_brew_prefix_memoization wget
saturate ls_brew_prefix_memoization not-a-package

echo && echo '~~~~~~~~ ls_brew_prefix ~~~~~~~~'
saturate ls_brew_prefix wget
saturate ls_brew_prefix not-a-package

echo && echo '~~~~~~~~ brew_ls_piped_grep ~~~~~~~~'
saturate brew_ls_piped_grep wget
saturate brew_ls_piped_grep not-a-package

echo && echo '~~~~~~~~ brew_ls_with_package ~~~~~~~~'
saturate brew_ls_with_package wget
saturate brew_ls_with_package not-a-package

echo && echo '~~~~~~~~ brew_prefix ~~~~~~~~'
saturate brew_prefix wget
saturate brew_prefix not-a-package

# too slow to bother with
#echo && echo '~~~~~~~~ brew install (straight-up) ~~~~~~~~'
#saturate brew_install wget
#saturate brew_install not-a-package
