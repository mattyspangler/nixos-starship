#!/usr/bin/env python3
"""
Cardiotop Device Driver for ModemManager.

This module provides a clean, robust, and elegant way to stream GPS data by
interacting with the ModemManager CLI. It follows best practices by
encapsulating logic within a dedicated class and provides data in a simple,
flat format consistent with other cardiotop device drivers.
"""

import asyncio
import json
import subprocess
import sys
import time
from typing import Any, AsyncGenerator, Dict, Optional, Union

# --- Constants ---
POLLING_INTERVAL_SECONDS = 5
ERROR_WAIT_SECONDS = 10

def _log(message: str, error: bool = False) -> None:
    """Prints a standardized log message to stderr."""
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    level = "ERROR" if error else "INFO"
    print(f"[{timestamp}] [modemmanager] [{level}] {message}", file=sys.stderr, flush=True)

class ModemManager:
    """
    A class to encapsulate all interactions with the ModemManager CLI (`mmcli`).
    """

    async def _run_mmcli_command(
        self, command: list[str], expect_json: bool
    ) -> Optional[Union[Dict[str, Any], bool]]:
        """
        Runs a shell command asynchronously.

        Args:
            command: The command and its arguments to execute.
            expect_json: If True, attempts to parse stdout as JSON.
                         If False, returns True on success.

        Returns:
            - A dictionary if expect_json is True and parsing succeeds.
            - True if expect_json is False and command succeeds.
            - None on any error.
        """
        try:
            process = await asyncio.create_subprocess_exec(
                *command,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            stdout, stderr = await process.communicate()

            if process.returncode != 0:
                _log(f"Command '{' '.join(command)}' failed: {stderr.decode().strip()}", error=True)
                return None

            if expect_json:
                return json.loads(stdout)
            else:
                return True  # Command succeeded
        except (json.JSONDecodeError, FileNotFoundError) as e:
            _log(f"Failed to execute or parse command output for '{' '.join(command)}': {e}", error=True)
            return None

    async def enable_gps(self) -> bool:
        """
        Enables the GPS functionality on the modem.

        Returns:
            True if GPS was enabled successfully, False otherwise.
        """
        _log("Enabling GPS NMEA and RAW data streams...")
        enable_nmea_cmd = ["mmcli", "-m", "any", "--location-enable-gps-nmea"]
        enable_raw_cmd = ["mmcli", "-m", "any", "--location-enable-gps-raw"]

        # These commands don't produce useful JSON, so just check for success.
        result_nmea = await self._run_mmcli_command(enable_nmea_cmd, expect_json=False)
        result_raw = await self._run_mmcli_command(enable_raw_cmd, expect_json=False)

        if result_nmea and result_raw:
            _log("GPS streams enabled successfully.")
            return True
        else:
            _log("Failed to enable one or more GPS data streams.", error=True)
            return False

    async def get_location_json(self) -> Optional[Dict[str, Any]]:
        """
        Fetches the latest location data from the modem in JSON format.

        Returns:
            A dictionary containing the full JSON output from mmcli, or None.
        """
        command = ["mmcli", "-m", "any", "--location-get", "--output-json"]
        result = await self._run_mmcli_command(command, expect_json=True)
        return result if isinstance(result, dict) else None

def _parse_location_data(raw_data: Dict[str, Any], profile: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    """
    Parses the raw JSON dictionary from mmcli into a flat cardiotop data format.

    Args:
        raw_data: The dictionary parsed from mmcli's JSON output.
        profile: The device profile, used to get the device name.

    Returns:
        A simple, flat dictionary with location data, or None if no valid fix is found.
    """
    try:
        location = raw_data["modem"]["location"]
        gps = location.get("gps", {})

        lat_str = gps.get("latitude")
        lon_str = gps.get("longitude")

        # mmcli uses "--" to indicate no data.
        if lat_str is None or lon_str is None or lat_str == "--" or lon_str == "--":
            _log("No valid GPS fix found in JSON. Waiting for satellite lock.")
            _log(f"Full JSON output for debugging:\n{json.dumps(raw_data, indent=2)}")
            return None

        alt_str = gps.get("altitude", "0.0")
        device_name = profile.get("device_name", "ModemManager GPS")

        return {
            "device_name": device_name,
            "timestamp": int(time.time()),
            "latitude": float(lat_str),
            "longitude": float(lon_str),
            "altitude": float(alt_str) if alt_str != "--" else 0.0,
            "type": "gps"
        }
    except (KeyError, ValueError, TypeError) as e:
        _log(f"Could not parse location data from JSON: {e}", error=True)
        _log(f"Problematic JSON:\n{json.dumps(raw_data, indent=2)}")
        return None

async def get_device_stream(profile: dict) -> AsyncGenerator[Dict[str, Any], None]:
    """
    The main factory function that connects to ModemManager and yields location data.
    This is the entry point called by `cardiotop-device`.

    Args:
        profile: The device profile configuration (unused in this driver).

    Yields:
        A simple, flat dictionary containing location data.
    """
    _log("Initializing ModemManager GPS driver.")
    modem = ModemManager()

    if not await modem.enable_gps():
        _log("Halting driver due to failure to enable GPS.", error=True)
        return

    _log("Starting to poll for location updates...")
    while True:
        raw_location_data = await modem.get_location_json()

        if raw_location_data:
            parsed_data = _parse_location_data(raw_location_data, profile)
            if parsed_data:
                yield parsed_data
        else:
            _log("Failed to get any data from mmcli.", error=True)

        # Wait before the next poll.
        await asyncio.sleep(POLLING_INTERVAL_SECONDS)


async def _test_driver() -> None:
    """A simple function to test the driver directly."""
    print("--- Testing ModemManager Driver ---")
    print("Press Ctrl+C to stop.")
    try:
        async for data in get_device_stream({}):
            print(json.dumps(data))
    except asyncio.CancelledError:
        print("\nTest stopped.")

if __name__ == "__main__":
    # This allows for direct testing of the module, e.g., `python -m devices.modemmanager`
    try:
        asyncio.run(_test_driver())
    except KeyboardInterrupt:
        print("\nTest interrupted by user.")