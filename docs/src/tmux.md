---
sidebar: auto
---

# tmux <Badge text="HEAD" type="warning"/>

> tmux is a terminal multiplexer. It lets you switch easily between several programs in one terminal, detach them (they keep running in the background) and reattach them to a different terminal.

[tmux wiki](https://github.com/tmux/tmux/wiki)

## Setup

### 1. Install binary

<code-group>
  <code-block title="macOS">
  ```sh
  brew install tmux --HEAD
  ```
  </code-block>

  <code-block title="popOS">
  ```sh
  apt-get install libevent-dev ncurses-dev build-essential bison pkg-config
  brew install tmux --HEAD
  ```
  </code-block>
</code-group>


:::warning
I'm using the most bleeding edge version (`--HEAD`) because it has popup support.
:::

See [homebrew](./homebrew)

### 2. Link dotfile

```sh
mackup restore
```

See [mackup](/mackup)

### 3. Install plugins (tpm)

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```

See [TMUX Plugin Manager (tpm)](https://github.com/tmux-plugins/tpm)

## Config

::: details ~/.config/tmux/tmux.conf
<<< @/mackup/.config/tmux/tmux.conf
:::

**Server edition:** this goes a long way without the plugin code.
::: details ~/.tmux.conf
<<< @/server/.tmux.conf
:::

## Commands

### Reload config

```sh
tmux source ~/.config/tmux/tmux.conf
```

### tpm

```sh
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/clean_plugins # uninstall / remove
~/.tmux/plugins/tpm/bin/update_plugins all
```
