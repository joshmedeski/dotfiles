# Josh Medeski's Dotfiles

![screenshot](./screenshot.png)

This is the home of all my dotfiles. These are special files that add custom configurations to my computer and applications, primarily the terminnal.

# Known Bugs

- [ ] Copilot `tab` doesn't work for copilot
- [ ] `eval (/opt/homebrew/bin/brew shellenv)` can't be used in config.fish. My brew node install is prioritized over my fnm node verisons (which I want to be the highest priority in the $PATH). For now, I'm manually adding homebrew items to the path.

```fish
# TODO: figure out how to add this back (see above)
# eval (/opt/homebrew/bin/brew shellenv)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
```

# Wishlist

- [ ] Convert Neovim to Lua
- [ ] Switch to native Neovim lsp
- [ ] Add additional keybindings for using Copilot
- [ ] When a pane is split, count the number of rows outputted by the previous command and resize it to that amount
- [ ] Bind <prefix> ? to display all keyboard shortcuts (including custom mappings). Create keymapping shortcut
- [ ] Extend `aw` to create custom Neovim theme (that matches Alacritty theme)
- [ ] Learn targets.vim https://www.barbarianmeetscoding.com/blog/exploring-vim-plugins-improve-and-extend-your-text-objects-with-targets-vim
- [ ] Bind <space>lf to popup lf and bind `e` to edit in existing neovim instance (using neovim remote?)
- [ ] Setup Obsidian / vimwiki setup

## Done

- [x] Have neovim auto run `tmux source-file ~/.tmux.conf` when `~/.tmux.conf` is saved (create vim plugin)
- [x] Tell neovim to automatically run `brew services restart yabai` when `~/.yabairc` is saved (in tmux split)

# Hardware

- Laptop: MacBook Pro (16-inch, 2021)
  - Chip: Apple M1 Pro
  - Memory: 16 GB
  - Mechanical Keyboard: Moonlander
  - Mouse: Logitech trackball

# Software

- Terminal: [Alacritty](https://alacritty.org)
- Font: [SFMono Nerd Font](https://github.com/epk/SF-Mono-Nerd-Font)
- Colors: [catppuccin](https://github.com/catppuccin/catppuccin)
- Shell: [fish](https://fishshell.com)
- Multiplexer: [tmux](https://github.com/tmux/tmux/wiki)
- Editor: [Neovim](https://neovim.io)
- Git: [lazygit](https://github.com/jesseduffield/lazygit)
- Package Manager: [Homebrew](https://brew.sh)

