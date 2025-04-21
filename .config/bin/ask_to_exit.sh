#!/usr/bin/env bash
echo "Press 'q' or 'esc' to exit"
while true; do
  read -rsn1 input # Read a single character without displaying it
  if [[ $input == "q" || $input == $'\x1b' ]]; then
    break # Exit the loop when "q" or "esc" is pressed
  fi
done
