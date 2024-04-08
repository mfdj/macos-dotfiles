#!/usr/bin/env bash

require functions/input-helpers
require functions/plist-helpers

# Set ComputerName, HostName, LocalHostName
# http://ilostmynotes.blogspot.com/2012/03/computername-vs-localhostname-vs.html
echo 'Ensuring ComputerName, HostName, LocalHostName are set'
if [[ ! -f $DOTFILES_DIR/local/machine-name ]]; then
   machine_name=$(scutil --get ComputerName)
   promptfor machine_name "Choose a machine name"
   sudo -i bash -c "
      scutil --set ComputerName $machine_name &&
      scutil --set HostName $machine_name &&
      scutil --set LocalHostName $machine_name" \
   && echo "$machine_name" > "$DOTFILES_DIR/local/machine-name"
fi

echo 'Ensuring Dock auto-hide'
autohide_dock=$(defaults read com.apple.dock autohide 2> /dev/null || true)
if [[ $autohide_dock != 1 ]]; then
   defaults write com.apple.dock autohide -bool true \
   && killall Dock
fi

echo 'Ensuring iTunes Half Star'
itunes_half_star=$(defaults read com.apple.iTunes allow-half-stars 2> /dev/null || true)
if [[ $itunes_half_star != 1 ]]; then
   defaults write com.apple.iTunes allow-half-stars -bool TRUE
fi

echo 'Ensuring mission-control symbolichotkeys are disabled (requires restart)'
for n in {32..37} {60..63}; do
   plist_disable ~/Library/Preferences/com.apple.symbolichotkeys.plist \
      :AppleSymbolicHotKeys:$n
done
# Reload symbolichotkeys (cache bust) http://stackoverflow.com/a/26564334/934195
defaults read com.apple.symbolichotkeys > /dev/null

echo 'Ensuring Terminal secure-keyboard-entry and option-as-meta'
# NOTE: security.stackexchange.com/questions/47749/how-secure-is-secure-keyboard-entry-in-mac-os-xs-terminal
if [[ "$(defaults read com.apple.Terminal SecureKeyboardEntry)" != 1 ]]; then
   defaults write com.apple.Terminal SecureKeyboardEntry -bool true
   defaults write com.apple.Terminal useOptionAsMetaKey -bool true
   defaults read com.apple.Terminal > /dev/null
fi

# use Homebrew installed bash
preferred_shell=$(brew --prefix)/bin/bash
if [[ -f $preferred_shell ]]; then
   echo "Ensuring use of preferred shell: $preferred_shell"

   if ! grep "$preferred_shell" /etc/shells -q; then
      echo "• adding '$preferred_shell' to /etc/shells"
      echo "• changing shell to '$preferred_shell'"
      echo '# dotfiles-setup added:' > ~/new-etc-shells
      { echo "$preferred_shell"
        echo
        cat /etc/shells
      } >> ~/new-etc-shells

      user=$(whoami)
      if sudo -s -- mv ~/new-etc-shells /etc/shells; then
         if chsh -s "$preferred_shell" "$user"; then
            echo 'start new session to use changed shell'
         fi
      fi
   elif [[ $SHELL != "$preferred_shell" ]]; then
      echo "• changing shell to '$preferred_shell'"
      if chsh -s "$preferred_shell"; then
         echo 'start new session to use changed shell'
      fi
   fi

   echo -n "$SHELL — " && $SHELL --version | head -n 1
fi

# Ensure startup sounds is off https://www.reddit.com/r/mac/comments/s8vb2u/how_nvram_deals_with_binary_data_values_of/?rdt=44885
# https://support.apple.com/en-us/HT211996 say this is available in Apple menu  > System Settings > Sounds
echo "Ensuring statup sounds is muted"
startup_mute=$(nvram StartupMute | awk '{print $2}' || true)
if [[ ! $startup_mute == '%01' ]]; then
   sudo nvram StartupMute=%01
fi
