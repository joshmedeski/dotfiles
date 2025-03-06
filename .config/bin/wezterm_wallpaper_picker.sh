#!/usr/bin/env bash

# local variable for full path of ~/.config/wezterm/wallpapers
WALLPAPER_DIR="$HOME/.config/wezterm/wallpapers"

# list all files (without .DS_STORE)
FILES=$(find "$WALLPAPER_DIR" -type f ! -name '.DS_STORE')

# put in fzf list
SELECTED_FILE=$(echo "$FILES" | fzf --preview "wezterm_wallpaper_setter.sh {}" --preview-window=bottom:1%)

if [ -n "$SELECTED_FILE" ]; then
  ENCODED_SELECTED_FILE=$(echo -n "$SELECTED_FILE" | base64)
  printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" WALLPAPER $ENCODED_SELECTED_FILE
fi
