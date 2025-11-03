#!/data/data/com.termux/files/usr/bin/bash
# .termux/boot/startbot.sh
# Example script for Termux:Boot to auto-start the bot on device boot.
# Install Termux:Boot, put this file under ~/.termux/boot/startbot.sh and make executable.

set -e

# Acquire wake lock
if command -v termux-wake-lock >/dev/null 2>&1; then
  termux-wake-lock
fi

cd "$HOME/StaticBot" || exit 0

# Minimal resilient loop for boot-time start
while true; do
  node index.js
  sleep 5
done
