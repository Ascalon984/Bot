#!/data/data/com.termux/files/usr/bin/bash
# start-termux.sh
# Helper script to run StaticBot in Termux with a resilient restart loop
# Usage:
#   1. Copy this file to your Termux home (~/StaticBot/start-termux.sh)
#   2. Make it executable: chmod +x start-termux.sh
#   3. Run: ./start-termux.sh

set -e

# Acquire wake lock so Android's Doze doesn't aggressively stop networking
if command -v termux-wake-lock >/dev/null 2>&1; then
  termux-wake-lock
  echo "termux-wake-lock acquired"
else
  echo "termux-wake-lock not available (is Termux installed?). Continuing without wake-lock..."
fi

cd "$HOME/StaticBot" || { echo "Project folder not found: $HOME/StaticBot"; exit 1; }

echo "Starting StaticBot (resilient loop). Press Ctrl+C to stop."
while true; do
  node index.js
  rc=$?
  echo "StaticBot exited with code $rc — restarting in 5s..."
  sleep 5
done
