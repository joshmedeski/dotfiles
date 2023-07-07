#!/bin/sh

case "$1" in
*.tar*) tar tf "$1" ;;
*.zip) unzip -l "$1" ;;
*) bat --force-colorization --paging=never --style=numbers --terminal-width $(($2 - 5)) -f "$1" ;;
esac
