
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com
# cSpell:words ajeetdsouza cppflags ldflags pkgconfig pnpm nvim Nord gopath nvimpager ripgreprc ripgrep zoxide joshmedeski sharkdp neovim lucc

starship init fish | source # https://starship.rs/
zoxide init fish | source # 'ajeetdsouza/zoxide'

set -gx fish_greeting # disable fish greeting
set -gx CPPFLAGS -I/opt/homebrew/opt/sqlite/include
set -gx LDFLAGS -L/opt/homebrew/opt/sqlite/lib
set -gx PKG_CONFIG_PATH /opt/homebrew/opt/sqlite/lib/pkgconfig
set -gx PNPM_HOME /Users/joshmedeski/Library/pnpm # https://pnpm.io/
set -Ux BAT_THEME Nord # 'sharkdp/bat' cat clone 
set -Ux EDITOR nvim # 'neovim/neovim' text editor 
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"

set -Ux FZF_DEFAULT_OPTS "--reverse --no-info --pointer='' --marker='' \
--ansi --color='16,bg+:-1,gutter:-1,prompt:4,pointer:5,marker:6'"

set -Ux FZF_TMUX_OPTS "-p --reverse --no-info --pointer='' --marker='' \
--ansi --color='16,bg+:-1,gutter:-1,prompt:4,pointer:5,marker:6'"

set -Ux FZF_CTRL_R_OPTS "--border-label=' History ' --prompt=' '"

set -U GOPATH (go env GOPATH) # https://golang.google.cn/
set -U KIT_EDITOR /opt/homebrew/bin/nvim # https://www.scriptkit.com/
set -U LANG en_US.UTF-8
set -U LC_ALL en_US.UTF-8
set -U NODE_PATH "~/.nvm/versions/node/v16.19.0/bin/node" # 'nvm-sh/nvm'
set -U PAGER ~/.local/bin/nvimpager # 'lucc/nvimpager'
set -U RIPGREP_CONFIG_PATH "$HOME/.config/rg/ripgreprc"
set -U VISUAL nvim

# ordered by priority - bottom up
fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/sqlite/bin
fish_add_path /opt/homebrew/opt/openjdk/bi
fish_add_path $GOPATH/bin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/tmux/plugins/tmux-nvr/bin
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin
fish_add_path $HOME/.config/bin # my custom scripts
