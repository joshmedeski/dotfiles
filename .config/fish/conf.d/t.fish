#
# t - the smart tmux session manager
# https://github.com/joshmedeski/t-smart-tmux-session-manager
#
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin
set -Ux T_FZF_FIND_BINDING 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)'
set -Ux T_FZF_PROMPT '🧠 '
set -Ux T_SESSION_USE_GIT_ROOT true
set -Ux T_REPOS_DIR ~/c

# set -Ux T_SESSION_NAME_INCLUDE_PARENT false
# set -Ux T_FZF_BORDER_LABEL 'the ultimate tmux tool'
# set -Ux T_FZF_DEFAULT_RESULTS 'sessions'
