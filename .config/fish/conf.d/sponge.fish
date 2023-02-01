# Sponge version
set --global sponge_version 1.1.0

# Allow to repeat previous command by default
if not set --query --universal sponge_delay
  set --universal sponge_delay 2
end

# Purge entries both after `sponge_delay` entries and on exit by default
if not set --query --universal sponge_purge_only_on_exit
  set --universal sponge_purge_only_on_exit false
end

# Add default filters
if not set --query --universal sponge_filters
  set --universal sponge_filters sponge_filter_failed sponge_filter_matched
end

# Don't filter out commands that already have been in the history by default
if not set --query --universal sponge_allow_previously_successful
  set --universal sponge_allow_previously_successful true
end

# Consider `0` the only successful exit code by default
if not set --query --universal sponge_successful_exit_codes
  set --universal sponge_successful_exit_codes 0
end

# No active regex patterns by default
if not set --query --universal sponge_regex_patterns
  set --universal sponge_regex_patterns
end

# Attach event handlers
functions --query \
  _sponge_on_prompt \
  _sponge_on_preexec \
  _sponge_on_postexec \
  _sponge_on_exit

# Initialize empty state for the first run
function _sponge_install --on-event sponge_install
  set --global _sponge_current_command ''
  set --global _sponge_current_command_exit_code 0
  set --global _sponge_current_command_previously_in_history false
end

# Clean up variables
function _sponge_uninstall --on-event sponge_uninstall
  _sponge_clear_state
  set --erase sponge_version
end
