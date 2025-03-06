#!/usr/bin/env bash

if [ -n "$1" ]; then
  ENCODED_COLOR_SCHEME=$(echo -n "$1" | base64)
  printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" COLOR_SCHEME $ENCODED_COLOR_SCHEME
fi
