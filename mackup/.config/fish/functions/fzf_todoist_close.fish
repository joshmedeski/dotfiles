function fzf_todoist_close
  todoist list | fzf | cut -d ' ' -f 1 | tr '\n' ' ' | sed -e 's/[ \t]*$//' | read ret 
  if [ $ret ]
    todoist close $ret
    commandline -f repaint
  end
end
