#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com/
# cSpell:words shellcode pkgx direnv

eval (/opt/homebrew/bin/brew shellenv)

# TODO: waiting for fish support
# https://github.com/pkgxdev/pkgx/issues/845
# source (pkgx --shellcode)

starship init fish | source # https://starship.rs/
zoxide init fish | source # 'ajeetdsouza/zoxide'
fzf --fish | source
fnm --log-level quiet env --use-on-cd | source # "Schniz/fnm"
direnv hook fish | source # https://direnv.net/
fx --comp fish | source # https://fx.wtf/
set -g direnv_fish_mode eval_on_arrow # trigger direnv at prompt, and on every arrow-based directory change (default)

set -U fish_greeting # disable fish greeting
# FIX: sesh connect won't actually start tmux
# function fish_greeting
#     if test -n "$TMUX"
#         return
#     else
#       sesh connect \"\$(sesh list -i | fzf --no-sort --ansi --prompt '⚡  ' --no-border --bind 'tab:down,btab:up' --preview-window 'right:60%:noborder' --preview 'sesh preview {}')\"
#     end
# end


set -U fish_key_bindings fish_vi_key_bindings
# set -U LANG en_US.UTF-8
# set -U LC_ALL en_US.UTF-8

set -Ux BAT_THEME "Catppuccin Latte" # 'sharkdp/bat' cat clone
set -Ux EDITOR nvim # 'neovim/neovim' text editor
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"

# TODO: fix colors of nvimpager
# set -Ux PAGER "~/.local/bin/nvimpager" # 'lucc/nvimpager'
set -Ux PAGER nvimpager

# NOTE: "noborus/ov" 🎑Feature-rich terminal-based text viewer. It is a so-called terminal pager.
# set -Ux PAGER ov

# golang - https://golang.google.cn/
set -Ux GOPATH (go env GOPATH)
fish_add_path $GOPATH/bin
fish_add_path $HOME/.rustup/toolchains/nightly-aarch64-apple-darwin/bin

fish_add_path $HOME/.config/bin # my custom scripts
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/Library/Python/3.9/bin

set copilot_cli_path (which github-copilot-cli)

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
#     eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" hook $argv | source
# else
#     if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
#         . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH /opt/homebrew/Caskroom/miniconda/base/bin $PATH
#     end
# end
# # <<< conda initialize <<<
export PATH="/Users/joshmedeski/.gdvm/bin/current_godot:/Users/joshmedeski/.gdvm/bin:$PATH"

alias claude="/Users/joshmedeski/.claude/local/claude"
