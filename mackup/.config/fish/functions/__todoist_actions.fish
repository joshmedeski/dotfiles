#!/usr/bin/env fish

function __todoist_actions
  set -l prefix __todoist_
  functions --all | grep '^__todoist_' | grep -v '__todoist_actions' | sed "s/^$prefix//" | fzf +m --reverse --header='Todoist:Actions' | read -l cmd; and eval "$prefix$cmd"
end
