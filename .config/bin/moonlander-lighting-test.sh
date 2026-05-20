#!/usr/bin/env bash

for i in $(seq 0 71); do
  kontroll set-rgb-all -c 000000
	kontroll set-rgb -l "$i" -c FF0000 || exit $?
  sleep 1
done
