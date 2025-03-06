#!/usr/bin/env bash

FILES=$(ls ~/c/iTerm2-Color-Schemes/wezterm/ | sed 's/.toml//g' | column -c 1)

# put in fzf list
CHOICE=$(echo "$FILES" | fzf --preview "wezterm_color_scheme_setter.sh {}" --preview-window=bottom:1%)

if [ -n "$SELECTED_FILE" ]; then
  ENCODED_SELECTED_FILE=$(echo -n "$CHOICE" | base64)
  printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" COLOR_SCHEME $ENCODED_SELECTED_FILE
fi
