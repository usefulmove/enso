#!/usr/bin/env bash
# Delegate a task to a child pi agent.
# Usage: ./delegate.sh <context-dir> <prompt-file> [session-name]

set -euo pipefail

CONTEXT_DIR="${1:-.}"
PROMPT_FILE="${2:-/dev/stdin}"
TMUX_NAME="${3:-}"

if [[ ! -d "$CONTEXT_DIR" ]]; then
  mkdir -p "$CONTEXT_DIR"
fi

if [[ ! -f "$PROMPT_FILE" && "$PROMPT_FILE" != "/dev/stdin" ]]; then
  echo "Error: prompt file does not exist: $PROMPT_FILE" >&2
  exit 1
fi

PROMPT=$(cat "$PROMPT_FILE")

if [[ -n "$TMUX_NAME" ]]; then
  tmux new-session -d -s "$TMUX_NAME" \
    "cd '$CONTEXT_DIR' && pi -p <<< '$PROMPT'"
  echo "tmux:$TMUX_NAME"
else
  cd "$CONTEXT_DIR"
  pi -p <<< "$PROMPT"
fi
