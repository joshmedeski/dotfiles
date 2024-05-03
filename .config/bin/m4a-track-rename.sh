#!/usr/bin/env bash

# Loop through all .m4a files in the current directory
for FILE in *.m4a; do
	# Check if the file is a regular file
	if [ -f "$FILE" ]; then
		# Extract metadata using ffprobe
		TITLE=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$FILE")
		ARTIST=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$FILE")

		# Clean the metadata to create a safe filename
		CLEAN_TITLE=$(echo "$TITLE" | sed 's/[<>:"/\\|?*]//g' | tr -d '\r\n' | sed 's/^\s*//;s/\s*$//')
		CLEAN_ARTIST=$(echo "$ARTIST" | sed 's/[<>:"/\\|?*]//g' | tr -d '\r\n' | sed 's/^\s*//;s/\s*$//')

		# Combine cleaned title and artist
		CLEAN_TRACK="$CLEAN_TITLE - $CLEAN_ARTIST"

		# Rename the file if both title and artist are available
		if [ -n "$CLEAN_TITLE" ] && [ -n "$CLEAN_ARTIST" ]; then
			echo "Renaming $FILE to $CLEAN_TRACK.m4a"
			mv "$FILE" "$CLEAN_TRACK.m4a"
		else
			echo "Metadata insufficient to rename $FILE."
		fi
	fi
done
