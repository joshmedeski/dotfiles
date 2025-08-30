#!/usr/bin/env bash

# local variable for full path of ~/.config/wezterm/wallpapers
WALLPAPER_DIR="$HOME/c/second-brain/Resources 🛠️/Wallpapers/"

# list only filenames (without .DS_STORE)
FILES=$(find "$WALLPAPER_DIR" -type f ! -name '.DS_STORE' -exec basename {} \;)

# put in fzf list
SELECTED_FILE=$(echo "$FILES" | fzf --preview "wezterm_wallpaper_setter.sh '$WALLPAPER_DIR/{}'" --preview-window=bottom:1%)

if [ -n "$SELECTED_FILE" ]; then
  # construct full path and encode it
  FULL_PATH="$WALLPAPER_DIR/$SELECTED_FILE"
  ENCODED_SELECTED_FILE=$(echo -n "$FULL_PATH" | base64)
  printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" WALLPAPER $ENCODED_SELECTED_FILE
fi

