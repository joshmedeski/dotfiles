---
sidebar: auto
---

# Getting Started

How to get started with dotfiles:

## Install Font

Download "FiraCode Nerd Font Mono" font [here](https://www.nerdfonts.com/font-downloads)

## Setup GitHub access

[Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/github-ae@latest/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Clone dotfiles repo

Clone [Josh's Dotfiles Repo](https://github.com/joshmedeski/joshs-dotfiles)

```sh
git clone git@github.com:joshmedeski/joshs-dotfiles.git dotfiles
```

:::tip
I recommend putting all your git repositories in one place (ex: `~/repos`)
:::

## Install Homebrew

[Homebrew homepage](https://brew.sh)

## Restore mackup

To restore mackup, run the following commands:

```sh
brew install mackup
cp ~/repos/joshs-dotfiles/mackup/.mackup.cfg ~/.mackup.cfg
mackup restore
```

This will copy all of the appropriate dotfiles from the repo to the home directory wherever the files are needed. See [mackup](https://github.com/lra/mackup) for more details.

:::warning
If you didn't clone the repo to `~/repos/joshs-dotfiles`, you'll have to change the values inside `~/.mackup.cfg`. If you don't copy the config file before running `mackup restore` it won't properly sync the files.
:::

`~/.mackup.cfg`

<<< @/../mackup/.mackup.cfg

## Install dependencies

`./bin/brew-install.sh`

<<< @/../bin/brew-install.sh
 

