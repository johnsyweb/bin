#!/bin/bash
#
# Automated Speedtest Script
#
# This script runs a speedtest and saves results to timestamped JSON files.
# It automatically rotates old files to keep only the last 72 hours of data.
#
# Launchd Configuration:
# - Installed as: ~/Library/LaunchAgents/com.speedtest.plist
# - Runs every hour (3600 seconds)
# - Auto-starts at login
# - Logs stdout to: /tmp/speedtest.out
# - Logs stderr to: /tmp/speedtest.err
#
# To manage the launchd job:
#   Load:   launchctl load ~/Library/LaunchAgents/com.speedtest.plist
#   Unload: launchctl unload ~/Library/LaunchAgents/com.speedtest.plist
#   Status: launchctl list | grep speedtest
#
# Results are saved to: ~/SpeedtestResults/speedtest_YYYYMMDD_HHMMSS.json
# Old files (>72 hours) are automatically deleted.

set -e -u -o pipefail

# Set full path to speedtest-cli for launchd compatibility
SPEEDTEST_CLI="/opt/homebrew/bin/speedtest-cli"

# Check if speedtest-cli exists
if [[ ! -x "$SPEEDTEST_CLI" ]]; then
    echo "Error: speedtest-cli not found at $SPEEDTEST_CLI. Please install it first." >&2
    exit 1
fi

RESULTS_DIR="$HOME/SpeedtestResults"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
OUTPUT_FILE="$RESULTS_DIR/speedtest_${TIMESTAMP}.json"
RETENTION_HOURS=72

if [[ ! -d "$RESULTS_DIR" ]]; then
    mkdir -p "$RESULTS_DIR"
else
    find "$RESULTS_DIR" -name "speedtest_*.json" -type f -mtime +$((RETENTION_HOURS / 24)) -delete
fi

"$SPEEDTEST_CLI" --share --json > "$OUTPUT_FILE"
echo "Speedtest results saved to: $OUTPUT_FILE"

