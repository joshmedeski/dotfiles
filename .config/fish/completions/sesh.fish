complete -c sesh -d 'Smart session manager' -f

set -l commands list connect clone

complete -c sesh -n "not __fish_seen_subcommand_from $commands" -s h -l help -d 'Show help message and exit'
complete -c sesh -n "not __fish_seen_subcommand_from $commands" -s v -l version -d 'Show version and exit'

# list
complete -c sesh -n "not __fish_seen_subcommand_from $commands" \
    -a list -d "List sessions"

complete -c sesh -n '__fish_seen_subcommand_from list' -s t -l tmux -d 'List tmux sessions'
complete -c sesh -n '__fish_seen_subcommand_from list' -s z -l zoxide -d 'List zoxide results'

complete -c sesh -n "not __fish_seen_subcommand_from $commands" \
    -a connect -d "Connect to a session"

complete -c sesh -n '__fish_seen_subcommand_from connect' -s z -l zoxide -d 'List zoxide results'

complete -c sesh -n "not __fish_seen_subcommand_from $commands" \
    -a clone -d "Git clone a new session"
