---
sidebar: auto
---

# tmux <Badge text="HEAD" type="warning"/>

> tmux is a terminal multiplexer. It lets you switch easily between several programs in one terminal, detach them (they keep running in the background) and reattach them to a different terminal.

[tmux wiki](https://github.com/tmux/tmux/wiki)

## Config

<<< @/../mackup/.config/tmux/tmux.conf

**Server edition:** this goes a long way without the plugin code.
<<< @/../server/.tmux.conf

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
