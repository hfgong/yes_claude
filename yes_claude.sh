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
    "Do you want to proceed?"
    "Would you like to proceed?"
    "Do you want to create"
    "❯ 1. Yes,"
)
PANE_TARGET=":${WINDOW_TARGET}.0"

# Combine the prompts into a single regex pattern
PROMPT_REGEX=$(IFS="|"; echo "${PROMPTS[*]}")

echo "Starting monitoring of tmux pane ${PANE_TARGET} for ${LOOPS} loops with an interval of ${INTERVAL} seconds."
echo "Looking for prompts: ${PROMPTS[*]}"

for i in $(seq 1 $LOOPS); do
    echo "Loop ${i}/${LOOPS}: Sleeping for ${INTERVAL} seconds..."
    sleep $INTERVAL

    echo "Checking for prompts in pane ${PANE_TARGET}..."
    if tmux capture-pane -p -t "$PANE_TARGET" | grep -qE "$PROMPT_REGEX"; then
        echo "Prompt found. Sending 'Enter' to select 'Yes'."
        tmux send-keys -H -t "$PANE_TARGET" 0D
    else
        echo "Prompt not found."
    fi
done

echo "Monitoring finished after ${LOOPS} loops. Prompt was not found."
exit 1
