#!/bin/bash

# A script to send a prompt to a specific tmux window (where Claude might be running)
# Usage: ./tell_claude.sh <window_target> <prompt message...>

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <window_target> <prompt message...>"
    exit 1
fi

WINDOW_TARGET=$1
shift
PROMPT_MESSAGE="$*"
PANE_TARGET=":${WINDOW_TARGET}.0"

# mac's tmux (often installed via brew) doesn't support -H (hex) flag.
# Linux tmux supports -H for sending raw hex codes (0D corresponds to Enter).
send_enter() {
    local target="$1"
    if [[ "$(uname)" == "Linux" ]]; then
        tmux send-keys -H -t "$target" 0D
    else
        tmux send-keys -t "$target" Enter
    fi
}

# echo "Sending prompt to pane ${PANE_TARGET}: ${PROMPT_MESSAGE}"

# Send the keys
tmux send-keys -t "$PANE_TARGET" "$PROMPT_MESSAGE"
send_enter "$PANE_TARGET"
