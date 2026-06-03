# Cached output of: /opt/homebrew/bin/brew shellenv
# Regenerate with: /opt/homebrew/bin/brew shellenv > ~/.config/fish/conf.d/brew.fish
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_REQUIRE_TAP_TRUST 1
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
fish_add_path -gP /opt/homebrew/bin /opt/homebrew/sbin
set -q MANPATH; or set MANPATH ''
set -gx MANPATH /opt/homebrew/share/man $MANPATH
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH
