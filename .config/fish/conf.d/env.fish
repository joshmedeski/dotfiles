# Non-PATH environment variables

# Lumen
set -Ux LUMEN_AI_PROVIDER "ollama"
set -Ux LUMEN_AI_MODEL "llama3.1:latest"

# Nutiliti
set -e MONGOMS_VERSION

# mas
set -gx MAS_NO_AUTO_INDEX 1

# Ollama
set -Ux OLLAMA_ORIGINS "app://obsidian.md*"
set -Ux OLLAMA_FLASH_ATTENTION 1
set -Ux OLLAMA_CONTEXT_LENGTH 8192

# SearXNG
set -x SEARXNG_URL "http://localhost:8080"

# Skim
set -Ux SKIM_DEFAULT_OPTIONS --reverse --ansi

# zf
set -Ux FZ_PROMPT ' '
set -Ux FZ_HIGHLIGHT green
set -Ux FZ_VI_MODE true
