# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a WezTerm terminal emulator configuration written in Lua. WezTerm is configured via `~/.config/wezterm/wezterm.lua` which returns a config table. Full API docs: https://wezterm.org/docs/config/files

## Architecture

**`wezterm.lua`** - Entry point. Builds the config table, registers event handlers, and returns the config. Key responsibilities:
- Rendering settings (WebGpu, 120fps)
- Font config (Maple Mono with Nerd Font fallback)
- Color scheme (Catppuccin Mocha/Latte, auto dark/light)
- Key bindings (CMD keys mapped to Neovim commands and tmux prefix sequences)
- Background wallpaper with adjustable opacity
- User-var event handlers for dynamic config overrides (wallpaper, color scheme, zen mode)

**`utils/`** - Reusable modules following the `local M = {} ... return M` pattern:
- **`keys.lua`** - Key binding helpers. `cmd_key()`, `cmd_to_tmux_prefix()` (sends Ctrl-b + key), `multiple_actions()` (types a string character-by-character, used for Neovim commands like `:w`)
- **`background.lua`** - Creates gradient overlay layers with dark/light opacity
- **`wallpaper.lua`** - Wallpaper selection from glob paths (random static or GIF)
- **`color_scheme.lua`** - Color scheme management. Uses Catppuccin Mocha (dark) / Latte (light) based on system appearance
- **`helpers.lua`** - `is_dark(appearance)` checks system dark mode, `get_random_entry(tbl)` picks random table element
- **`files.lua`** - `.DS_Store` filtering utility

**`plugins/wezterm-live-wallpaper/`** - Local plugin that downloads a live wallpaper image (NOAA satellite) on a timer and applies it as background. Has its own git repo.

## Key Patterns

- **Dark/light mode**: `wezterm.gui.get_appearance()` returns "Dark" or "Light". The `helpers.is_dark()` function checks this. Many settings branch on it.
- **Dynamic config**: `window:get_config_overrides()` / `window:set_config_overrides()` pattern is used extensively for runtime changes without restart.
- **User variables**: External tools (like Neovim) set user vars via escape sequences to trigger WezTerm config changes (wallpaper, color scheme, zen mode font size).
- **Tmux integration**: Most CMD+key bindings send `Ctrl-b` (tmux prefix) followed by a tmux key. The tmux prefix is hardcoded as `Ctrl-b`.
- **Type annotations**: Uses `@type Wezterm` and `@type Config` from [wezterm-types](https://github.com/DrKJeff16/wezterm-types) for LSP support.

## Development

No build/test/lint commands - this is a Lua config loaded directly by WezTerm. Changes take effect on save (WezTerm watches the config file). Use `wezterm.log_info()` / `wezterm.log_error()` for debugging; logs viewable via `wezterm cli list` or the debug overlay (Ctrl+Shift+L).

Wallpaper images go in `wallpapers/` directory. Animations go in `animations/`.
