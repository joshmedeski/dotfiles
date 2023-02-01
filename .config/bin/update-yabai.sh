#!/bin/bash

echo "yabai updating..."

# stop, upgrade, start yabai
brew services stop yabai
brew upgrade yabai
brew services start yabai

# reinstall the scripting addition
sudo yabai --uninstall-sa
sudo yabai --install-sa

# load the scripting addition
killall Dock

echo "yabai update complete"
