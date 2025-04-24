#!/bin/sh
set -e

# Start the React app in the background
pnpm run start --host &

# Then run your Python manager in the foreground
python3 BrowserManager.py
