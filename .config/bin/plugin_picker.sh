#!/usr/bin/env bash
# pick a plugin folder and start a sesh session in it

#########################################
# 1.  Map “AREA name” → real directory  #
#     (one entry per line, key:path)    #
#########################################
PLUGIN_MAP=(
  "neovim:$HOME/.local/share/nvim/lazy"
  "lazy:$HOME/.local/share/nvim/lazy"
  "stream_deck:$HOME/c/std/plugins"
  "obsidian:$HOME/c/second-brain/.obsidian/plugins"
  "tmux:$HOME/.config/tmux/plugins"
  "obs:$HOME/Library/Application Support/obs-studio/plugins"
)

############################
# 2. Pick the desired AREA #
############################
AREA=$(printf '%s\n' "${PLUGIN_MAP[@]}" |
  cut -d':' -f1 |
  sort | 
  fzf-tmux -p 100%,100% --no-border \
  --list-border \
  --no-sort --prompt '🧩 ' \
  --input-border \
  --header-border \
  --bind 'tab:down,btab:up' \
  --preview-window 'right:70%' \
  --preview 'lsd {}' \
       ) \
       || exit 0               # user hit <ESC>

##############
# 2b. Resolve the directory mapped to that AREA
##############
PLUGINS_DIR=""
for entry in "${PLUGIN_MAP[@]}"; do
  key=${entry%%:*}
  val=${entry#*:}
  if [[ $key == "$AREA" ]]; then
    PLUGINS_DIR=${val/\~/$HOME} # expand leading ~
    break
  fi
done

[[ -n $PLUGINS_DIR && -d $PLUGINS_DIR ]] || {
  echo "❌  Directory for “$AREA” not found." >&2
  exit 1
}

########################################################
# 3. Pick a plugin / folder inside the chosen AREA     #
#    (only first level; change -maxdepth/-type as needed)
########################################################
# TODO: set `dark` value as $LIGHT_DARK type variable globally in wezterm as exported variable
PLUGIN=$(ls -1 "$PLUGINS_DIR" |
  sort |
  fzf-tmux \
  -p 100%,100% \
  --prompt "🧩 " \
  --no-sort \
  --no-border \
  --list-border \
  --input-border \
  --header-border \
  --bind "tab:down,btab:up" \
  --preview-window "right:70%" \
  --preview "CLICOLOR_FORCE=1 COLORTERM=truecolor glow -s dark $PLUGINS_DIR/{}/README.md 2>/dev/null || lsd --icon=always --color=always --tree --depth 2 $PLUGINS_DIR/{}"
) || exit 0
FULL="$PLUGINS_DIR/$PLUGIN"

#####################################
# 4. Fire up sesh in that directory #
#####################################
echo "▶️  sesh connect '$FULL'"
sesh connect "$FULL"

