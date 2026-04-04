#!/bin/bash

# publish-be.sh
# Safely restarts the NodeCrypto backend server

echo "🔍 Finding existing backend process on port 8080..."
PID=$(lsof -ti:8080)

if [ -n "$PID" ]; then
    echo "🛑 Killing existing process $PID..."
    kill -9 $PID
else
    echo "✅ No existing process found on port 8080."
fi

echo "🚀 Starting NodeCrypto Server..."
# Running in the background or foreground depending on use case. 
# Here we just run it normally so the user sees the output.
swift run NodeCryptoServer
