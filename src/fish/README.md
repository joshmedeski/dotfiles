---
sidebar: auto
---

# fish

> fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.

[fishshell.com](http://fishshell.com)

## Setup

### 1. Install binary

<code-group>
  <code-block title="brew">
  ```sh
  brew install fish
  ```
  </code-block>

  <code-block title="apt-get">
  ```sh
  sudo apt-get install fish
  ```
  </code-block>
</code-group>

### 2. Link dotfile

```sh
mackup restore
```

### 3. Change default shell

:::warning
The path to fish will change depending on what machine you use to install it. `/opt/homebrew/bin/fish` may be something else on your computer.
:::

Copy path to fish

<code-group>
<code-block title="macOS">
```sh
which fish | pbcopy
```
</code-block>

<code-block title="linux">
```sh
xclip -selection clipboard < which fish
```
</code-block>
</code-group>

Edit shells
```sh
sudo vi /etc/shells
```

Paste clipboard to the top of the file

```sh{1}
/opt/homebrew/bin/fish
/bin/bash
/bin/csh
/bin/dash
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
```

Save and quit (`:wq`)

Run change shell
```sh
sudo chsh -s /opt/homebrew/bin/fish
```

Close and reopen your terminal, it should automatically load the fish shell.

### 4. Install plugins (fisher)

```sh
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher
```

> A plugin manager for Fish—the friendly interactive shell.

[github.com/jorgebucaran/fisher](https://github.com/jorgebucaran/fisher)

## Config

::: details ~/.config/fish/config.fish
<<< @/mackup/.config/fish/config.fish
:::

## Commands

### Reload config

```sh
source ~/.config/fish/config.fish
```
