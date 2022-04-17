#!/usr/bin/env fish

function __todoist_close
  command todoist list | fzf --reverse --header='CloseTask' -m | cut -d ' ' -f 1 | tr '\n' ' ' | read -l tasks
  
  set cmd "todoist close "
  if not test -z $tasks
      set cmd "$cmd""$tasks"
      echo $cmd
      eval $cmd
  end
end
