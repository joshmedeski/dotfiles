function fzf_todoist_project
  todoist projects | fzf | head -n1 | cut -d ' ' -f 1 | read ret
  if [ $ret ]
    set buf (commandline | sed -e 's/[ \t]*$//')
    commandline "$buf -P $ret"
  end
end
