#!/usr/bin/env bash

WALL_DIR="$HOME/c/second-brain/Assets/Wallpapers"

if [[ ! -d "$WALL_DIR" ]]; then
    printf 'Directory not found: %s\n' "$WALL_DIR" >&2
    exit 1
fi

    selection="$(
        find "$WALL_DIR" -type f \
            \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.tif' -o -iname '*.tiff' \) \
            -print 2>/dev/null |
            fzf --prompt='Wallpapers> ' \
                --preview-window='right,60%,border-left' \
                --bind='ctrl-/:toggle-preview' \
                --preview 'wezterm imgcat --width "${FZF_PREVIEW_COLUMNS:-80}" --height "${FZF_PREVIEW_LINES:-24}" -- "$f"
               '
    )"

    return selection

