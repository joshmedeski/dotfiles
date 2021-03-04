function fzf_git_pull_request
  set -l query (commandline --current-buffer)
  if test -n $query
    set fzf_query --query "$query"
  end

  set -l base_command gh pr list --limit 100
  set -l bind_commands "ctrl-a:reload($base_command --state all)"
  set bind_commands $bind_commands "ctrl-o:reload($base_command --state open)"
  set bind_commands $bind_commands "ctrl-c:reload($base_command --state closed)"
  set bind_commands $bind_commands "ctrl-g:reload($base_command --state merged)"
  set bind_commands $bind_commands "ctrl-a:reload($base_command --state all)"
  set -l bind_str (string join ',' $bind_commands)

  set -l out ( \
    command $base_command | \
    fzf $fzf_query \
        --prompt='Select Pull Request>' \
        --preview="gh pr view {1}" \
        --expect=ctrl-k,ctrl-m \
        --header='enter: open in browser, C-k: checkout, C-a: all, C-o: open, C-c: closed, C-g: merged, C-a: all' \
  )
  if test -z $out
    return
  end
  set -l pr_id (echo $out[2] | awk '{ print $1 }')
  if test$out[1] = 'ctrl-k'
    commandline "gh pr checkout $pr_id"
    commandline -f execute
  else if test $out[1] = 'ctrl-m'
    commandline "gh pr view --web $pr_id"
    commandline -f execute
  end
end 
