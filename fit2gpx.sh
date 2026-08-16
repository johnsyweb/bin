#!/bin/bash

set -e -o pipefail

if ! command -v gpsbabel &> /dev/null
then
    echo "GPSBabel is not installed. Please install it first."
    echo "On Ubuntu/Debian: sudo apt-get install gpsbabel"
    echo "On macOS with Homebrew: brew install gpsbabel"
    exit 1
fi

for file in *.fit; do
    gpsbabel -i garmin_fit -f "$file" -o gpx -F "${file%.fit}.gpx"
    echo "Converted $file to ${file%.fit}.gpx"
done
