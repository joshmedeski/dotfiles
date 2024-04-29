#!/usr/bin/env bash

FILE="$1"

TITLE=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$FILE")
ARTIST=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$FILE")
CLEAN_TITLE=$(echo "$TITLE" | sed 's/[<>:"/\\|?*]//g' | tr -d '\r\n' | sed 's/^\s*//;s/\s*$//')
CLEAN_ARTIST=$(echo "$ARTIST" | sed 's/[<>:"/\\|?*]//g' | tr -d '\r\n' | sed 's/^\s*//;s/\s*$//')
CLEAN_TRACK="$CLEAN_TITLE - $CLEAN_ARTIST"
echo "Renaming $FILE to $CLEAN_TRACK.m4a"
mv "$FILE" "$CLEAN_TRACK.m4a"
