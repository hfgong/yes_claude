# yes_claude.sh

A simple shell script to monitor a tmux window for a specific prompt and automatically "answer" yes by sending an Enter key.

## Use Case

This script is useful for situations where you are running a process in a tmux window that may occasionally prompt for confirmation to proceed, and you want to automate the "yes" response for non-dangerous operations.

## Usage

```bash
./yes_claude.sh <window_target> <interval_seconds> <loops>
```

### Arguments

*   `<window_target>`: The target tmux window to monitor (e.g., `0` or a window name like `claude`).
*   `<interval_seconds>`: The time in seconds to wait between each check.
*   `<loops>`: The total number of times to check the window before exiting if the prompt is not found.

### Example

To monitor tmux window `0` every 30 seconds for 10 cycles:

```bash
./yes_claude.sh 0 30 10
```

## Customization

The script searches for the prompt "Do you want to proceed?". You can change this by editing the `PROMPT_TEXT` variable within the `yes_claude.sh` script.
