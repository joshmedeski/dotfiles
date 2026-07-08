#!/usr/bin/env bash
# Pick an Ollama model with fzf and print its name to stdout.
# Usage: model=$(./ollama-fzf.sh) && echo "$model"

set -euo pipefail

ollama list \
  | tail -n +2 \
  | fzf --height=40% --reverse --prompt="ollama model> " \
        --header="Select a model" \
  | awk '{print $1}'
