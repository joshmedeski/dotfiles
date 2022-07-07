#!/bin/sh
# store pwd in a variable
ZOXIDE_RESULT=$(zoxide query $1)

# if empty exit
if [ -z "$ZOXIDE_RESULT" ]; then
  exit 0
fi

# get folder name
FOLDER=$(basename $ZOXIDE_RESULT)

# lookup tmux session name
SESSION=$(tmux list-sessions | grep $FOLDER | awk '{print $1}')
SESSION=${SESSION//:/}

# check if variable is empty 
# if not currently in tmux
if [ -z "$TMUX" ]; then
  # tmux is not active
  echo "is not tmux"
  if [ -z "$SESSION" ]; then
    # session does not exist
    echo "session does not exist"
    # jump to directory
    cd $ZOXIDE_RESULT
    # create session
    tmux new-session -s $FOLDER
  else
    # session exists
    echo "session exists"
    # attach to session
    tmux attach -t $SESSION
  fi
else
  # tmux is active
  echo "is tmux"
  if [ -z "$SESSION" ]; then
    # session does not exist
    echo "session does not exist"
    # jump to directory
    cd $ZOXIDE_RESULT
    # create session
    tmux new-session -d -s $FOLDER
    # attach to session
    tmux switch-client -t $FOLDER
  else
    # session exists
    echo "session exists"
    # attach to session
    # switch to tmux session
    tmux switch-client -t $SESSION
  fi
fi
