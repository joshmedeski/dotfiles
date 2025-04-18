#!/usr/bin/env bash

# loop through all ollama results
MODELS=$(gum spin --spinner globe --title " Pulling models" --show-output -- ollama list | awk '{print $1}' | grep -v '^$')

echo "Testing all models..."
for MODEL in $MODELS; do
  if [[ "$MODEL" == "NAME" ]]; then
    echo "Skipping the 'ollama' model..."
    continue
  fi
  RESULT=$(gum spin --spinner globe --title "Testing model: $MODEL" --show-output -- lumen -p ollama -m "$MODEL" draft)
  echo "Result for model $MODEL:"
  echo "$RESULT"
done
