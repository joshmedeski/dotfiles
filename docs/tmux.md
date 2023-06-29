---
id: "tmux"
aliases:
  - "tmux"
tags: []
---

# tmux

https://twitter.com/elijahmanor/status/1667272757065785345

```conf
bind-key e send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter
```

https://github.com/mskelton/tmux-last`

```conf
set -g @plugin 'mskelton/tmux-last'
```

https://github.com/fcsonline/tmux-thumbs

```conf
set -g @plugin 'fcsonline/tmux-thumbs'
```

Recommended by [[Elijah Manor]]
