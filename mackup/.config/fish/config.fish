# cSpell enable:wfxr tmux fzf url neovim
#
# https://fishshell.com/docs/current/language.html

set fish_greeting # disable fish greeting

starship init fish | source # 
zoxide init fish | source

set -U LANG en_US.UTF-8 # language
set -U LC_ALL en_US.UTF-8

set -U BAT_THEME Nord # 'sharkdp/bat' cat clone 

set -U EDITOR nvim # 'neovim/neovim' hyperextensible Vim-based text editor 

# fzf 'wfxr/tmux-fzf-url'
set -U FZF_CTRL_R_OPTS "--border-label=' History ' --prompt=' '"
set -U FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -U FZF_DEFAULT_OPTS "--reverse --no-info --prompt=' ' --pointer='' --marker='' --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U FZF_TMUX_OPTS "-p --no-info --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"

# https://golang.google.cn/
set -U GOPATH (go env GOPATH)

set -U KIT_EDITOR /opt/homebrew/bin/nvim
set -U PAGER ~/.local/bin/nvimpager # 'lucc/nvimpager'

set -U NODE_PATH "~/.nvm/versions/node/v16.19.0/bin/node"
set -gx PNPM_HOME /Users/joshmedeski/Library/pnpm

# path (ordered by priority - bottom up)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.config/bin # my custom scripts
fish_add_path $HOME/.config/tmux/plugins/tmux-nvr/bin
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.fig/bin

# pnpm autocomplete
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# nvr
if test -n "$TMUX"
    eval (string replace "NVIM_LISTEN_ADDRESS=" "set -x NVIM_LISTEN_ADDRESS " (tmux show-environment -s NVIM_LISTEN_ADDRESS))
else
    set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
end

# sqlite
fish_add_path /opt/homebrew/opt/sqlite/bin
set -gx LDFLAGS -L/opt/homebrew/opt/sqlite/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/sqlite/include
set -gx PKG_CONFIG_PATH /opt/homebrew/opt/sqlite/lib/pkgconfig

# colors
set -U fish_color_autosuggestion black
set -U fish_color_command normal
set -U fish_color_error red
set -U fish_color_param cyan
set -U fish_color_redirections yellow
set -U fish_color_terminators white
set -U fish_color_valid_path green

# aliases
alias aw "~/.config/aw/bin/run"
alias pn pnpm
