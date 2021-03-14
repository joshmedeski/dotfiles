---
sidebar: auto
---

# TODO dotfiles

## Inbox

- [ ] <cmd+shift+m> opens Spotify tui in new tmux tab
- [ ] Make it easier to delete entries from the cli history using fzf's default popup
- [ ] Check out [yarn typescript plugin](https://www.npmjs.com/package/@yarnpkg/plugin-typescript)
- [ ] Bind cmd+/ to toggle comments in vim
- [x] Create setup page in dotfiles
- [ ] Create `nvm` tutorial for macOS, linux
- [ ] Create a fzf script that can update the macos wallpaper
- [ ] Add my uses to https://uses.tech
- `TODO` Setup mosh servers on any/all OS

### Update fisher’s ctrl+t

Add to show all files tmux-fzf command:

- [ ] Sort by most recent updated
- [ ] Show preview
- [ ] Open to nvim-remote

### Alacritty import for keyboard shortcuts

- Write simple script for people to install

```
$ curl https://github.com/joshmedeski/alacritty-macos-keyboard-shortcuts/master/install.sh
```

This will download the `macos-keyboard-shortcuts.yml` file into your `~/.config/alacritty` folder.

File structure in `~/.config/alacritty`
- alacritty.yml - main file
- keyboard.yml - keyboard 
- mouse.yml - mouse settings
- plugins - plugins

Does it matter that I break this up? Do I just recommend people copy/paste my settings and put it in their alacritty config file.


## Quick tmux switching 

`t` command

- [ ] Bind keyboard to holding `t` will trigger `<c-t>`
	- [ ] Create fish script that runs when you run `t {name}`
	- [ ] Script will conditionally check the following things
		- [ ] If session already exists, switch to it
		- [ ] If session doesn’t exist: z to the name, create new session
- [ ] `<c-t>` is bound to `~/.tmux/t` history file
	- [ ] Create `~/.tmux/t` file
- [ ] Integrate with `fzf-tmux`
- [ ] Display active tmux sessions to the side (—preview)
