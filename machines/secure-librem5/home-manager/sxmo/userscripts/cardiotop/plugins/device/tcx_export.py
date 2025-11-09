#!/usr/bin/env python
#
# TCX exporter for cardiotop-device
#
# For a full reference on the TCX format, see:
# https://www.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd
#
# For a good real-world example, see the output of GoldenCheetah.
#
import atexit
import json
import sys
from datetime import datetime, timezone

class TCXExporter:
    def __init__(self, profile_name: str, tcx_file: str):
        self.profile_name = profile_name
        self.tcx_file = tcx_file
        self.trackpoints = []
        atexit.register(self.write_tcx_file)

    def process(self, data: dict):
        # We only care for data points that have a heart rate
        if "heart_rate" not in data:
            return

        # TCX timestamps require Zulu time (UTC) in ISO 8601 format
        timestamp = datetime.now(timezone.utc).isoformat()
        
        trackpoint = {
            "time": timestamp,
            "heart_rate": data["heart_rate"]
        }
        self.trackpoints.append(trackpoint)

    def write_tcx_file(self):
        if not self.trackpoints:
            return # Don't write empty files

        start_time = self.trackpoints[0]["time"]

        # TCX file structure is quite verbose
        tcx_content = f"""<?xml version="1.0" encoding="UTF-8"?>
<TrainingCenterDatabase
  xsi:schemaLocation="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2 http://www.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd"
  xmlns:ns5="http://www.garmin.com/xmlschemas/ActivityGoals/v1"
  xmlns:ns3="http://www.garmin.com/xmlschemas/ActivityExtension/v2"
  xmlns:ns2="http://www.garmin.com/xmlschemas/UserProfile/v2"
  xmlns="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  xmlns:ns4="http://www.garmin.com/xmlschemas/ProfileExtension/v1">
  <Activities>
    <Activity Sport="Other">
      <Id>{start_time}</Id>
      <Lap StartTime="{start_time}">
        <TotalTimeSeconds>{len(self.trackpoints)}</TotalTimeSeconds>
        <DistanceMeters>0</DistanceMeters>
        <Calories>0</Calories>
        <Intensity>Active</Intensity>
        <TriggerMethod>Manual</TriggerMethod>
        <Track>
"""
        for tp in self.trackpoints:
            tcx_content += f"""          <Trackpoint>
            <Time>{tp["time"]}</Time>
            <HeartRateBpm>
              <Value>{tp["heart_rate"]}</Value>
            </HeartRateBpm>
          </Trackpoint>
"""
        tcx_content += """        </Track>
      </Lap>
    </Activity>
  </Activities>
</TrainingCenterDatabase>
"""
        with open(self.tcx_file, "w") as f:
            f.write(tcx_content)
        print(f"Wrote TCX file to {self.tcx_file}", file=sys.stderr)

if __name__ == "__main__":
    # First arg is profile name, second is TCX file path
    if len(sys.argv) != 3:
        print("Usage: tcx_export.py <profile_name> <tcx_file>", file=sys.stderr)
        sys.exit(1)

    exporter = TCXExporter(profile_name=sys.argv[1], tcx_file=sys.argv[2])

    try:
        for line in sys.stdin:
            try:
                data = json.loads(line)
                exporter.process(data)
            except json.JSONDecodeError:
                # Ignore malformed JSON
                continue
    except KeyboardInterrupt:
        sys.exit(0)