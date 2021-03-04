function fzf_todoist_delete
  todoist list | fzf | cut -d ' ' -f 1 | tr '\n' ' ' | sed -e 's/[ \t]*$//' | read ret 
  if [ $ret ]
    todoist delete $ret
    commandline -f repaint
  end
end
