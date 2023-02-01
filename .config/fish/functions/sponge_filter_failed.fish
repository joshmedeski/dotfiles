function sponge_filter_failed \
  --argument-names command exit_code previously_in_history

  if test $previously_in_history = true -a $sponge_allow_previously_successful = true
    return 1
  end

  if contains $exit_code $sponge_successful_exit_codes
    return 1
  end
end
