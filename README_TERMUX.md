# Running StaticBot on Termux (Android)

This guide explains how to run the StaticBot WhatsApp auto‑reply bot on Android using Termux. It includes a helper script and an example Termux:Boot startup script.

Prerequisites
- Termux (install from F‑Droid for latest updates)
- Node.js (available via `pkg install nodejs`)
- Git
- A second device with WhatsApp for scanning the QR on first run

Quick start
1. Update Termux packages:
   ```bash
   pkg update && pkg upgrade -y
   pkg install git nodejs -y
   ```
2. Clone the repository and install dependencies:
   ```bash
   cd $HOME
   git clone https://github.com/Ascalon984/StaticBot.git
   cd StaticBot
   npm install
   ```
3. Start the bot (first run will show QR in terminal):
   ```bash
   node index.js
   ```
   Scan the displayed QR with WhatsApp on another device.

Keep the bot running
- Use the included `start-termux.sh` script to run the bot in a restart loop.
  Make it executable and run it:
  ```bash
  chmod +x start-termux.sh
  ./start-termux.sh
  ```
- For auto-start after reboot, install Termux:Boot and place `.termux/boot/startbot.sh` (already included in this repo) in your Termux home under `~/.termux/boot/` and make it executable.

Stability tips
- Run `termux-wake-lock` to keep CPU awake for networking.
- Exclude Termux from battery optimization in Android settings.
- Store `auth_info` in the project folder (already default). Don't commit it to GitHub.

If you want, I can commit these helper files to the repo (start script + Termux:Boot example). They are already included in this workspace.
