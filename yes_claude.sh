#!/bin/bash

# A script to monitor a tmux window for a specific prompt and interact with it.

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <window_target> <interval_seconds> <loops>"
    exit 1
fi

WINDOW_TARGET=$1
INTERVAL=$2
LOOPS=$3
PROMPT_TEXT="Do you want to proceed?"

echo "Starting monitoring of tmux window ${WINDOW_TARGET} for ${LOOPS} loops with an interval of ${INTERVAL} seconds."

for i in $(seq 1 $LOOPS); do
    echo "Loop ${i}/${LOOPS}: Sleeping for ${INTERVAL} seconds..."
    sleep $INTERVAL

    echo "Checking for prompt in window ${WINDOW_TARGET}..."
    if tmux capture-pane -p -t "$WINDOW_TARGET" | grep -q "$PROMPT_TEXT"; then
        echo "Prompt found. Sending 'Enter' to select 'Yes'."
        tmux send-keys -t "$WINDOW_TARGET" C-m
        echo "Monitoring finished."
        exit 0
    else
        echo "Prompt not found."
    fi
done

echo "Monitoring finished after ${LOOPS} loops. Prompt was not found."
exit 1
