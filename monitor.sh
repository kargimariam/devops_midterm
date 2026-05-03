#!/bin/bash

# Configuration
URL="http://localhost:3000/api/health"
LOG_FILE="health-check.log"
INTERVAL=60 # seconds

echo "Starting Monitoring Service..."
echo "Logging to $LOG_FILE"
echo "Press Ctrl+C to stop monitoring."
echo "Checking $URL every $INTERVAL seconds..."

while true; do
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  RESPONSE=$(curl -s $URL)
  
  if [ $? -eq 0 ]; then
    STATUS=$(echo $RESPONSE | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
    echo "[$TIMESTAMP] Health check: $STATUS" >> $LOG_FILE
  else
    echo "[$TIMESTAMP] Health check: FAILED (Server Down)" >> $LOG_FILE
  fi
  
  sleep $INTERVAL
done
