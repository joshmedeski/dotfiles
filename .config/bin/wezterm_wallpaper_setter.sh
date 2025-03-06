#!/usr/bin/env bash

if [ -n "$1" ]; then
  ENCODED_SELECTED_FILE=$(echo -n "$1" | base64)
  printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" WALLPAPER $ENCODED_SELECTED_FILE
fi
