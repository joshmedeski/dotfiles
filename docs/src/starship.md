---
sidebar: auto
---

# starship 

> ☄🌌️ The minimal, blazing-fast, and infinitely customizable prompt for any shell!

[github.com/starship/starship](https://github.com/starship/starship)

## Setup

### 1. Install binary

```sh
brew install starship
```

See [homebrew](./homebrew) for more info on managing packages.

### 2. Link dotfile

Make sure `yabai` is listed in your `~/.mackup.conf`

```sh{2}
[applications_to_sync]
Starship
```

Link `~/repos/dotfiles/mackup/.config/starship.toml` to `~/.config/starship.toml` by running the following command 
```sh
mackup restore
```

See [mackup](/mackup) for more info on how linking dotfiles works.

### 3. Add the init script to your shell's config file

I'm using [fish](/fish), and the following line in already in `~/.config/fish/config.fish`

```sh
starship init fish | source
```

## Config

::: details ~/.config/starship.toml
<<< @/../mackup/.config/starship.toml
:::

