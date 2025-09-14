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
# - Runs every 10 minutes (600 seconds)
# - Auto-starts at login
# - Logs stdout to: /tmp/speedtest.out (with timestamps)
# - Logs stderr to: /tmp/speedtest.err (with timestamps)
#
# To manage the launchd job:
#   Load:   launchctl load ~/Library/LaunchAgents/com.speedtest.plist
#   Unload: launchctl unload ~/Library/LaunchAgents/com.speedtest.plist
#   Status: launchctl list | grep speedtest
#
# Results are saved to: ~/SpeedtestResults/speedtest_YYYYMMDD_HHMMSS.json
# Old files (>72 hours) are automatically deleted.

set -e -u -o pipefail

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")

log() {
    echo "[$TIMESTAMP] $1"
}

log_error() {
    echo "[$TIMESTAMP] $1" >&2
}

check_command() {
    local cmd="$1"

    if ! command -v "$cmd" >/dev/null 2>&1; then
        log_error "Error: $cmd not found. Please install it with: brew install $cmd"
        exit 1
    fi
}

check_command "speedtest-cli"
check_command "jc"
check_command "jq"

RESULTS_DIR="$HOME/SpeedtestResults"
OUTPUT_FILE="$RESULTS_DIR/speedtest_${TIMESTAMP}.json"
RETENTION_HOURS=72

if [[ ! -d "$RESULTS_DIR" ]]; then
    mkdir -p "$RESULTS_DIR"
else
    find "$RESULTS_DIR" -name "speedtest_*.json" -type f -mtime +$((RETENTION_HOURS / 24)) -delete
fi

# Get network interface data - find first active interface with IPv4
IFCONFIG_DATA=$(ifconfig -v | jc --ifconfig 2>/dev/null | jq '[.[] | select(.status == "active" and .ipv4_addr)][0] // {}' 2>/dev/null || echo "{}")

if ! SPEEDTEST_RESULT=$(speedtest-cli --secure --share --json 2>/dev/null); then
    log_error "Warning: Speedtest command failed, storing failure datapoint"
    # Create a failure datapoint with timestamp and network interface data
    FAILURE_DATA=$(jq -n \
        --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)" \
        --argjson ifconfig "$IFCONFIG_DATA" \
        '{
            "timestamp": $timestamp,
            "download": null,
            "upload": null,
            "ping": null,
            "server": null,
            "share": null,
            "error": "Speedtest command failed",
            "x-ifconfig": $ifconfig
        }')
    echo "$FAILURE_DATA" > "$OUTPUT_FILE"
elif [[ -z "$SPEEDTEST_RESULT" ]]; then
    log_error "Warning: Speedtest failed to return data, storing failure datapoint"
    FAILURE_DATA=$(jq -n \
        --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)" \
        --argjson ifconfig "$IFCONFIG_DATA" \
        '{
            "timestamp": $timestamp,
            "download": null,
            "upload": null,
            "ping": null,
            "server": null,
            "share": null,
            "error": "Speedtest failed to return data",
            "x-ifconfig": $ifconfig
        }')
    echo "$FAILURE_DATA" > "$OUTPUT_FILE"
else
    echo "$SPEEDTEST_RESULT" | jq --argjson ifconfig "$IFCONFIG_DATA" '. + {"x-ifconfig": $ifconfig}' > "$OUTPUT_FILE"
fi

log "Speedtest results saved to: $OUTPUT_FILE"

