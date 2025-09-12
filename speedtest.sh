#!/bin/bash
#
# Automated Speedtest Script
#
# This script runs a speedtest and saves results to timestamped JSON files.
# It automatically rotates old files to keep only the last 72 hours of data.
# It also captures network interface information (en0) for additional context.
#
# Dependencies:
# - speedtest-cli (install with: brew install speedtest-cli)
# - jc (install with: brew install jc)
# - jq (install with: brew install jq)
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

# Check if jc exists
if ! command -v jc >/dev/null 2>&1; then
    echo "Error: jc not found. Please install it with: brew install jc" >&2
    exit 1
fi

# Check if jq exists
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq not found. Please install it with: brew install jq" >&2
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

# Capture network interface information
IFCONFIG_DATA=$(ifconfig -v | jc --ifconfig | jq '.[] | select(.name == "en0")' 2>/dev/null || echo "{}")

# Run speedtest and capture results
SPEEDTEST_RESULT=$("$SPEEDTEST_CLI" --share --json 2>/dev/null)

# Check if speedtest was successful
if [[ -z "$SPEEDTEST_RESULT" ]]; then
    echo "Error: Speedtest failed to return data" >&2
    exit 1
fi

# Add network interface data to the results
echo "$SPEEDTEST_RESULT" | jq --argjson ifconfig "$IFCONFIG_DATA" '. + {"x-ifconfig": $ifconfig}' > "$OUTPUT_FILE"

echo "Speedtest results saved to: $OUTPUT_FILE"

