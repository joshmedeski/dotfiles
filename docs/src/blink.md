---
sidebar: auto
---

# Blink

> THE PRO TERMINAL FOR iOS & iPadOS

https://blink.sh

# The following tmux settings will help improve the experience on iPapOS

```
bind-key -n MouseUp2Status kill-window -t= # Middle click on the window label to kill it
bind-key -n DoubleClick1Status new-window # Double click on the window list to open a new window
set -g mouse on
set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
```

**Note:** In order to use the better mouse mode plugin you'll have to properly set up [tpm](https://github.com/tmux-plugins/tpm)
