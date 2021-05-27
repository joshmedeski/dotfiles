#!/usr/bin/env fish

function __todoist_show
  command todoist list | fzf --reverse --header='ShowTask' --preview='command todoist show {1}' +m | cut -d ' ' -f 1 | tr '\n' ' ' | read -l tasks
  
  set cmd "todoist show "
  if not test -z $tasks
      set cmd "$cmd""$tasks"
      echo $cmd
      eval $cmd
  end
end
