# wezterm-live-wallpaper

A WezTerm plugin that periodically downloads an image from a URL and sets it as the terminal background. The URL should point to a regularly-updated image (e.g. a NOAA satellite feed).

## Usage

```lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local live_wallpaper = wezterm.plugin.require("https://github.com/joshmedeski/wezterm-live-wallpaper")

live_wallpaper.apply_to_config(config, {
  url = "https://cdn.star.nesdis.noaa.gov/GOES16/ABI/CONUS/GEOCOLOR/2500x1500.jpg",
})

return config
```

## Options

| Option | Default | Description |
|---|---|---|
| `url` | **(required)** | URL of the image to download |
| `refresh_interval` | `300` | Seconds between re-downloads |
| `cache_dir` | `~/.cache/wezterm` | Directory to store the downloaded image |
| `cache_filename` | `live-wallpaper.jpg` | Filename for the cached image |
| `dark_overlay_opacity` | `0.85` | Overlay opacity in dark mode |
| `light_overlay_opacity` | `0.65` | Overlay opacity in light mode |
| `wallpaper_opacity` | `1` | Opacity of the wallpaper layer |
| `overlay` | `nil` | Custom function `f(appearance)` returning a background layer |

## How it works

1. On config load, the image is downloaded from `url` to `cache_dir/cache_filename`
2. The wallpaper and an overlay layer are set on `config.background`
3. A `gui-startup` event starts a recurring timer that re-downloads the image every `refresh_interval` seconds and updates all open windows
