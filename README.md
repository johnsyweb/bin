# Speedtest Visualization Tools

This repository contains tools for visualizing speedtest data with comprehensive metadata including network interface information and public IP detection.

## Features

- **Automated speedtest collection** - Hourly speedtests with launchd
- **Network interface metadata** - Captures en0 interface details
- **Public IP detection** - Color-coded charts based on IP type
- **Interactive web charts** - Rich hover tooltips with clickable URLs
- **Local timezone display** - All timestamps shown in local time
- **Data export** - CSV export with complete dataset
- **Comprehensive reporting** - Summary statistics and detailed tables

## Files Overview

### Core Scripts
- `speedtest.sh` - Automated speedtest collection script
- `com.speedtest.plist` - Launchd configuration for hourly execution

### TypeScript Implementation
- `speedtest-viz.ts` - TypeScript-based visualization tool
- `package.json` - Node.js project configuration
- `tsconfig.json` - TypeScript compiler configuration
- `install_speedtest_deps.sh` - Dependencies installer

## Quick Start

### 1. Install Dependencies

```bash
./install_speedtest_deps.sh
```

### 2. Run Speedtests

```bash
# Run a single speedtest
./speedtest.sh

# Set up automated hourly testing
launchctl load ~/Library/LaunchAgents/com.speedtest.plist
```

### 3. Visualize Data

```bash
# Interactive web chart with clickable URLs and public IP detection
npx ts-node speedtest-viz.ts --interactive

# Summary statistics with local timezone
npx ts-node speedtest-viz.ts --summary

# Detailed table with IP type information
npx ts-node speedtest-viz.ts --detailed

# Export to CSV with both UTC and local timestamps
npx ts-node speedtest-viz.ts --csv data.csv

# Or use compiled version
npm run build
node dist/speedtest-viz.js --interactive
```

## Data Structure

Speedtest results are saved as JSON files in `~/SpeedtestResults/` with the following structure:

```json
{
  "timestamp": "2025-09-12T04:11:17.302664+00:00Z",
  "download": 235094892.4549563,
  "upload": 20065685.585938457,
  "ping": 10.739,
  "server": {
    "name": "Melbourne",
    "country": "Australia",
    "sponsor": "Encoo",
    "d": 12.047217425890194
  },
  "client": {
    "isp": "Superloop",
    "country": "AU",
    "ip": "116.255.18.156"
  },
  "share": "http://www.speedtest.net/result/18214317402.png",
  "x-ifconfig": {
    "name": "en0",
    "ipv4_addr": "192.168.0.68",
    "mac_addr": "f8:73:df:1b:aa:92",
    "mtu": 1500,
    "state": ["UP", "BROADCAST", "SMART", "RUNNING", "SIMPLEX", "MULTICAST"]
  }
}
```

## Command Line Options

- `--summary, -s` - Print summary statistics with local timezone
- `--detailed, -d` - Print detailed table with IP type information
- `--interactive, -i` - Generate interactive web chart with clickable URLs
- `--csv <file>` - Export data to CSV with UTC and local timestamps
- `--results-dir <dir>` - Specify results directory (default: ~/SpeedtestResults)

## Interactive Charts

The interactive web charts provide:

- **Hover tooltips** - Rich metadata display with local timestamps
- **Clickable URLs** - Click data points to open speedtest results
- **Public IP detection** - Color-coded points (red for public, blue for private)
- **Dual y-axes** - Speeds (Mbps) and ping (ms) on separate scales
- **Responsive design** - Adapts to different screen sizes
- **Professional styling** - Clean, modern appearance
- **Cross-platform** - Works on any system with a web browser

## Dependencies

- `speedtest-cli` - Speed test execution
- `jc` - JSON conversion from ifconfig
- `jq` - JSON processing
- `Node.js` - Runtime environment
- `TypeScript` - Language compiler
- `ts-node` - TypeScript execution
- `@types/node` - Node.js type definitions

## Automation

The system is designed for continuous monitoring:

1. **Hourly execution** - Launchd runs speedtests every hour
2. **Automatic cleanup** - Keeps only last 72 hours of data
3. **Error handling** - Graceful handling of network issues
4. **Metadata capture** - Network interface information included

## Output Files

- `speedtest_interactive.html` - Interactive web chart with clickable URLs
- `speedtest_data.csv` - Complete data export with UTC and local timestamps
- `~/SpeedtestResults/speedtest_YYYYMMDD_HHMMSS.json` - Individual test results

## License

MIT License - see individual files for details.