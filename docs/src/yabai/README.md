---
sidebar: auto
---

# yabai <Badge text="macOS" />

> A tiling window manager for macOS based on binary space partitioning

[github.com/koekeishiya/yabai](https://github.com/koekeishiya/yabai)

## Setup

### 1. Install binary

See [Installing yabai (latest release)](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release))

:::warning
[Apple Silicon M1 #725](https://github.com/koekeishiya/yabai/issues/725) isn't fully supported yet.
:::

See [homebrew](./homebrew) for more info on managing packages.

### 2. Link dotfile

Make sure `yabai` is listed in your `~/.mackup.conf`

```sh{2}
[applications_to_sync]
yabai
```

Link `~/repos/dotfiles/mackup/.yabirc` to `~/.yabarc` by running the following command 
```sh
mackup restore
```

See [mackup](/mackup) for more info on how linking dotfiles works.

## Config

::: details ~/.yabairc
<<< @/mackup/.yabairc
:::

## Commands

### Reload

```sh
brew services restart yabai
```

### Update yabai

See [Updating to the latest release](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#updating-to-the-latest-release)

