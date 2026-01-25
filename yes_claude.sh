#!/bin/bash

# A script to monitor a tmux window for a specific prompt and interact with it.

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <window_target> <interval_seconds> <loops>"
    exit 1
fi

WINDOW_TARGET=$1
INTERVAL=$2
LOOPS=$3
PROMPTS=(
    "Do you want to "
    "Would you like to "
    "❯ 1. Yes,"
)
PANE_TARGET=":${WINDOW_TARGET}.0"

# Combine the prompts into a single regex pattern
PROMPT_REGEX=$(IFS="|"; echo "${PROMPTS[*]}")

echo "Starting monitoring of tmux pane ${PANE_TARGET} for ${LOOPS} loops with an interval of ${INTERVAL} seconds."
echo "Looking for prompts: ${PROMPTS[*]}"


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

for i in $(seq 1 $LOOPS); do
    echo "Loop ${i}/${LOOPS}: Checking for prompts in pane ${PANE_TARGET}..."
    if tmux capture-pane -p -t "$PANE_TARGET" | grep -qE "$PROMPT_REGEX"; then
        echo "Prompt found. Sending 'Enter' to select 'Yes'."
        send_enter "$PANE_TARGET"
    elif [ $((i % 100)) -eq 0 ]; then
        echo "Periodic check (every 100 loops). Sending 'Enter' anyway."
        send_enter "$PANE_TARGET"
    else
        echo "Prompt not found."
    fi

    sleep $INTERVAL
done

echo "Monitoring finished after ${LOOPS} loops. Prompt was not found."
exit 1
