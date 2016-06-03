cask_ensure  atom
cask_ensure  flux
cask_ensure  kaleidoscope
cask_ensure  knox
cask_ensure  macdown
cask_ensure  shiftit
cask_ensure  slack
cask_ensure  sourcetree
cask_ensure  vlc
cask_ensure  sequel-pro

# prefer system Chrome if it's installed (fixes issues with 1password extension)
[[ -d /Applications/Google\ Chrome.app ]] || cask_ensure google-chrome
