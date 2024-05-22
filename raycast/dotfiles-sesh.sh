#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title dotfiles
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Sesh

# Documentation:
# @raycast.description Open dotfiles
# @raycast.author joshmedeski
# @raycast.authorURL https://raycast.com/joshmedeski

/Users/joshmedeski/go/bin/sesh connect --switch "dotfiles"
open -a "Wezterm"
