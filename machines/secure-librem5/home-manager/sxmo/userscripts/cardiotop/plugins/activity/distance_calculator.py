#!/usr/bin/env python3

import sys
import json
from geopy.distance import geodesic

def main():
    """
    Calculates cumulative distance from a stream of GPS coordinates.
    Reads cardiotop-formatted JSON from stdin, adds a "distance" field
    to the "activity" block, and prints the modified JSON to stdout.
    """
    last_coords = None
    total_distance_km = 0.0

    # Default to miles if no config is provided
    config_str = sys.argv[1] if len(sys.argv) > 1 else '{}'
    config = json.loads(config_str)
    units = config.get("units", "miles")

    for line in sys.stdin:
        try:
            data = json.loads(line)
            
            # Ensure the activity block exists
            if "activity" not in data:
                data["activity"] = {}

            current_coords = None
            # Find the first device with lat/lon
            for device in data.get("devices", {}).values():
                if "gps" in device and "lat" in device["gps"] and "lon" in device["gps"]:
                    lat = device["gps"]["lat"]
                    lon = device["gps"]["lon"]
                    if lat is not None and lon is not None:
                        current_coords = (lat, lon)
                        break
            
            if current_coords and last_coords:
                # geodesic returns distance in km.
                distance_delta_km = geodesic(last_coords, current_coords).kilometers
                total_distance_km += distance_delta_km

            last_coords = current_coords

            # Add distance to the activity block
            if units == "miles":
                total_distance_display = total_distance_km * 0.621371
                display_units = "mi"
            else: # Default to kilometers
                total_distance_display = total_distance_km
                display_units = "km"

            data["activity"]["distance"] = f"{total_distance_display:.2f} {display_units}"
            
            print(json.dumps(data), flush=True)

        except (json.JSONDecodeError, KeyError):
            # Pass through lines that are not valid JSON or are missing keys
            print(line, end="", flush=True)
            continue

if __name__ == "__main__":
    # This allows the script to be tested by piping a file with JSON lines
    main()