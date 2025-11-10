#!/usr/bin/env python3

import sys
import json
import subprocess

def main():
    """
    Connects to gpsd via gpspipe and streams location data as cardiotop-compatible JSON.
    """
    try:
        # gpspipe -w outputs JSON objects from gpsd
        # We use stdbuf to ensure the output is line-buffered
        process = subprocess.Popen(
            ["stdbuf", "-o0", "gpspipe", "-w"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
    except FileNotFoundError:
        print(json.dumps({"error": "gpspipe or stdbuf not found. Is gpsd installed and running?"}), flush=True)
        sys.exit(1)

    for line in iter(process.stdout.readline, ''):
        try:
            data = json.loads(line)
            # A TPV report with mode >= 2 has a 2D fix (lat/lon)
            if data.get("class") == "TPV" and data.get("mode", 0) >= 2:
                output = {
                    "gps": {
                        "lat": data.get("lat"),
                        "lon": data.get("lon"),
                        "speed": data.get("speed", 0),
                        "alt": data.get("alt", 0)
                    }
                }
                print(json.dumps(output), flush=True)
        except (json.JSONDecodeError, KeyError):
            # Ignore lines that aren't valid JSON or don't have the keys we need
            continue

if __name__ == "__main__":
    main()