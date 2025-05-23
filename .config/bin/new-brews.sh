#!/usr/bin/env bash

# example list from brew
# codex            cookcli          cpdf             e2b              hellwal          jjui             nelm             nerdlog          pieces-cli       pixd             smenu            tmuxai

# TODO: parse all of these into a list to loop
LIST=$1
# turn list into array
IFS=' ' read -r -a array <<<"$LIST"
# loop through array and brew info each one
for i in "${array[@]}"; do
  brew info "$i"
  echo -e "\n\n\n"

done
