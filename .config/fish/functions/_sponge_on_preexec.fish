function _sponge_on_preexec --on-event fish_preexec \
  --argument-names command
  _sponge_clear_state

  set --global _sponge_current_command $command

  builtin history search --case-sensitive --exact --max=1 --null $command \
    | read --local --null found_entries

  # If a command is in the history and in the queue, ignore it, like if it wasn’t in the history
  if test (count $found_entries) -ne 0; and not contains $command $_sponge_queue
    set --global _sponge_current_command_previously_in_history true
  else
    set --global _sponge_current_command_previously_in_history false
  end
end
