#!/bin/bash

for sound in /System/Library/Sounds/*.aiff; do
  name=$(basename "$sound" .aiff)
  echo "$name"
  /usr/bin/afplay "$sound"
done
