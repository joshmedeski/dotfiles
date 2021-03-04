#!/bin/bash

tmux new-session -d -s htop-session 'htop';  # start new detached tmux session, run htop
tmux split-window;                             # split the detached tmux session
tmux send 'htop -t' ENTER;                     # send 2nd command 'htop -t' to 2nd pane. I believe there's a `--target` option to target specific pane.
tmux a;                                        # open (attach) tmux session.

# TODO attach to session
tmux new-windows -d -n brew

# homebrew
tmux split-window
tmux split-window
# brew update
brew upgrade
tmux split-window -h
brew cleanup
brew doctor
tmux split-window

# npm
# npm -g outdated
# npm -g update

# update fisher
# fisher self-update
