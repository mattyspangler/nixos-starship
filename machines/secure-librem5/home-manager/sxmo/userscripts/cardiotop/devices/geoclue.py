#!/usr/bin/env python3
"""
Cardiotop Device Driver for GeoClue2.

Connects to the GeoClue2 D-Bus service to get location updates. This is the
standard and recommended way to access location information on modern Linux
systems like postmarketOS, as it abstracts the underlying hardware (GPS,
Wi-Fi, cellular) and manages power efficiently.
"""

import asyncio
import time
import sys

try:
    from dasbus.connection import SystemMessageBus
    from dasbus.loop import EventLoop
except ImportError:
    print("[geoclue] ERROR: The 'dasbus' library is required but not installed.", file=sys.stderr)
    print("[geoclue] Please install it, e.g., 'pip install dasbus'", file=sys.stderr)
    sys.exit(1)

# --- Globals ---
# GeoClue2 D-Bus details
GEOCLUE_BUS_NAME = "org.freedesktop.GeoClue2"
GEOCLUE_MANAGER_PATH = "/org/freedesktop/GeoClue2/Manager"
ACCURACY_LEVEL_EXACT = 1 # Corresponds to GeoclueAccuracyLevel.EXACT

def log(message: str, error: bool = False):
    """Prints a log message to stderr."""
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    print(f"[{timestamp}] [geoclue] {message}", file=sys.stderr, flush=True)

async def get_device_stream(profile: dict):
    """
    Connects to the GeoClue2 D-Bus service and yields location data.

    This function requests a location client from the GeoClue Manager,
    starts location updates, and listens for the 'LocationUpdated' signal.

    Args:
        profile (dict): The device profile configuration.

    Yields:
        dict: A dictionary containing timestamp, location, and accuracy data.
    """
    loop = EventLoop()
    try:
        bus = SystemMessageBus()
        manager = bus.get_proxy(GEOCLUE_BUS_NAME, GEOCLUE_MANAGER_PATH)

        # Create a client for our application
        # The desktop_id must match a .desktop file in /usr/share/applications/
        # or a similar directory for GeoClue to authorize the request.
        # We'll use a common one as a stand-in. If this fails, the user may
        # need to create a simple .desktop file for cardiotop.
        desktop_id = profile.get("desktop_id", "cardiotop")
        client_path = manager.GetClient()
        client = bus.get_proxy(GEOCLUE_BUS_NAME, client_path)
        client.DesktopId = desktop_id
        client.RequestedAccuracyLevel = ACCURACY_LEVEL_EXACT

        log("GeoClue client created. Starting location updates...")
        client.Start()

    except Exception as e:
        log(f"Failed to set up GeoClue D-Bus client: {e}", error=True)
        log("Please ensure GeoClue2 service is running and you have permissions.", error=True)
        log("You may need to run: /usr/libexec/geoclue-2.0/demos/agent", error=True)
        return

    # Queue for passing data from the D-Bus callback to the async generator
    update_queue = asyncio.Queue()

    def on_location_updated(old_location_path, new_location_path):
        """D-Bus signal handler for location updates."""
        try:
            location = bus.get_proxy(GEOCLUE_BUS_NAME, new_location_path)
            data = {
                "timestamp": int(location.Timestamp.to_unix_timestamp()),
                "latitude": location.Latitude,
                "longitude": location.Longitude,
                "altitude": location.Altitude,
                "accuracy": location.Accuracy,
                "type": "gps"
            }
            # Use run_coroutine_threadsafe for thread safety
            asyncio.run_coroutine_threadsafe(update_queue.put(data), asyncio.get_running_loop())
        except Exception as e:
            log(f"Error processing location update signal: {e}", error=True)

    # Subscribe to the signal
    client.LocationUpdated.connect(on_location_updated)

    try:
        log("Waiting for location updates from GeoClue...")
        while True:
            # Wait for data from the callback
            data = await update_queue.get()
            yield data
            update_queue.task_done()

    except asyncio.CancelledError:
        log("Stream cancelled. Stopping location updates.")
    finally:
        log("Cleaning up GeoClue client.")
        client.Stop()
        loop.quit()

if __name__ == "__main__":
    # This allows testing the driver directly.
    # Example: python -m devices.geoclue
    async def test_driver():
        print("Testing GeoClue driver. Press Ctrl+C to stop.")
        async for data in get_device_stream({}):
            print(data)

    try:
        asyncio.run(test_driver())
    except KeyboardInterrupt:
        print("\nTest stopped.")
