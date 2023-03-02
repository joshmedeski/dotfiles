#!/usr/bin/env bash

case "$1" in
*) bat --force-colorization --paging=never --style=changes,numbers \
	--terminal-width $(($2 - 3)) "$1" && false ;;
esac
