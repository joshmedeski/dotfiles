# dotfiles

This is the home of all my dotfiles. These are special files that add custom configurations to my computer and applications, primarily the terminnal.

# TODO

- [ ] Setup `mosh` for Blink
- [ ] Setup ssh key for iPadOS Blink shell
- [ ] Enable coc-spelling on markdown files 
- [ ] Setup https certificate for my mac (while developing)
- [ ] Combine fzf with previewing a wallpaper desktop

## TODO TMUX

- [ ] When a pane is split, count the number of rows outputted by the previous command and resize it to that amount
- [ ] Have neovim auto run `tmux source-file ~/.tmux.conf` when `~/.tmux.conf` is saved (create vim plugin)
- [ ] Bind <prefix> ? to display all keyboard shortcuts (including custom mappings). Create keymapping shortcut
- [ ] Fork and create my own `man tmux` page?
- [ ] Setup neovim-remote to combine with custom tmux commands (like lf)
- [ ] Add tmux-fzf popup that can kill a process on macOS
- [ ] Find a good system for saving a session and all it's windows and panes for reuse
- [ ] Create a tmux script that prompts the user for a previously saved session to restore (ex: nvimrc)
- [ ] Write article about how to theme your tmux theme (yourself, no plugins)
- [ ] bind escape key while in yank mode to quit escape mode (currently does nothing)

## TODO Yabai

- [ ] Tell neovim to automatically run `brew services restart yabai` when `~/.yabairc` is saved (in tmux split)
- [ ] Learn how new stacking feature works and add appropriate keybindings
- [ ] Learn the new full screen layout (related to stacking?) and add apporopriate keybindings
- [ ] Learn to use vim diff to stage hunks for comitting

## TODO Vim

- [ ] Setup neovim remote to work with tmux commands
- [ ] Learn targets.vim https://www.barbarianmeetscoding.com/blog/exploring-vim-plugins-improve-and-extend-your-text-objects-with-targets-vim
- [ ] Bind <space>lf to popup lf and bind `e` to edit in existing
- [ ] Neovim-remote server and close the lf popup
- [ ] Bind vimwiki obsidian page to open Obisidian in preview mode on the current file

# Hardware

- Desktop: M1 Mac Mini
  - Keyboard: Moonlander
- Laptop (replacement): iPad Pro (12.9-inch) (3rd generation)
  - Keyboard: Magic Keyboard
  - Mouse: Logitech trackball

# Apps

- Terminal:
  - Alacritty
  - Blink

# Software

- Package Manager: Homebrew
- Shell: Fish
- Multiplexer: tmux
- Editor: Neovim
- Git: lazygit

# Appearance

- Font: Fira Code Nerd Font
- Colors: Nord
