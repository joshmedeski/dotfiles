#!/usr/bin/env bash
# Checks wretched.computer for Crazy Taxi Part 2 blog post

page=$(curl -s https://wretched.computer/)

if echo "$page" | grep -qi "Part 2"; then
  url=$(echo "$page" | grep -i "Part 2" | grep -oE 'href="[^"]+"' | head -1 | sed 's/href="//;s/"//')
  remindctl add --list "Inbox" --title "Read Crazy Taxi Part 2 https://wretched.computer${url}"
fi
