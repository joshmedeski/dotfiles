#!/usr/bin/env fish

function __todoist_add
  get --prompt="Enter a task name:> " | read -l task
  seq 4 | fzf --reverse --header='AddTask:Priority' | read -l priority
  command todoist labels | fzf --reverse --header='AddTask:Label' -m | cut -d ' ' -f 1 | tr '\n' ',' | sed -e 's/,$//' | read -l labels
  command todoist projects | fzf --reverse --header='AddTask:Project' | head -n1 | cut -d ' ' -f 1 | read -l project
  for i in (seq 0 14)
    command date --date="+$i day" +'%m/%d (%a)'
  end | fzf --reverse --header='AddTask:Date' | cut -d ' ' -f 1 | read -l date_str
  
  set -l cmd 'todoist add '

  if not test -z $priority
      set cmd "$cmd""--priority $priority "
  end
  
  if not test -z $labels
      set cmd "$cmd""--label-ids $labels "
  end
  
  if not test -z $project
      set cmd "$cmd""--project-id $project "
  end
  
  if not test -z $date_str
      set cmd "$cmd""--date $date_str "
  end
  
  set cmd "$cmd""\"$task\""
  
  echo $cmd
  eval $cmd 
end