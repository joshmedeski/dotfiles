---
sidebar: auto
---

# fish

> fish is a smart and user-friendly command line shell for Linux, macOS, and the rest of the family.

[fishshell.com](http://fishshell.com)

## Config

<<< @/../mackup/.config/fish/config.fish

## Fisher Package Manager

> A plugin manager for Fish.

[github.com/jorgebucaran/fisher](https://github.com/jorgebucaran/fisher)

### Packages

```
edc/bass
FabioAntunes/fish-nvm
franciscolourenco/done
james2doyle/omf-plugin-fnm
joshmedeski/fish-fzf-todoist
upamune/fish-todoist
```

## Commands

### Reload config

```sh
source ~/.config/fish/config.fish
```

## Change default shell

Here are instructions for how to change the default shell to fish.

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

Close and reopen your terminal, it should automatically load the fish shell. If on linux, you'll have to logout and back in again.

