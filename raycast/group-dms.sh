#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Group DMs
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💬
# @raycast.packageName Window Management

# Documentation:
# @raycast.description Groups Discord and Messages
# @raycast.author joshmedeski
# @raycast.authorURL https://raycast.com/joshmedeski

open -a "Discord"
sleep 0.1
open -g "raycast://extensions/raycast/window-management/first-two-thirds"

open -a "Messages"
sleep 0.1
open -g "raycast://extensions/raycast/window-management/last-third"
