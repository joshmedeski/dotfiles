function fzf_git_issue
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l base_command gh issue list --limit 100
  set -l bind_commands "ctrl-a:reload($base_command --state all)"
  set bind_commands $bind_commands "ctrl-o:reload($base_command --state open)"
  set bind_commands $bind_commands "ctrl-c:reload($base_command --state closed)"
  set -l bind_str (string join ',' $bind_commands)

  set -l out ( \
    command $base_command | \
    fzf $fzf_query \
        --prompt='Open issue list >' \
        --preview "gh issue view {1}" \
        --bind $bind_str \
        --header='C-a: all, C-o: open, C-c: closed' \
  )
  if test -z $out
    return
  end
  set -l issue_id (echo $out | awk '{ print $1 }')
  commandline "gh issue view -w $issue_id"
  commandline -f execute
end

