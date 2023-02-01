function _sponge_on_prompt --on-event fish_prompt
  if test $sponge_purge_only_on_exit = false
    _sponge_remove_from_history
  end
end
