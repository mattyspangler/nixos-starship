"""
Common BLE logic for device modules.
"""

import asyncio
import sys
from bleak import BleakClient, BleakScanner

async def ble_stream_manager(profile: dict, compatible_models: list[str], notify_uuid: str, notification_handler):
    """
    Generic BLE stream manager. Connects to a device address from a profile.
    """
    address = profile.get("address")
    device_name = profile.get("device_name", "Unknown Device")  # Fallback for display name

    if not address:
        print("Error: Profile is missing the required 'address' key.", file=sys.stderr, flush=True)
        return

    # `compatible_models` is kept for future use, e.g. validating a profile's
    # model_name against the models supported by this module.

    print(f"Connecting to {device_name} ({address})...", file=sys.stderr, flush=True)

    try:
        async with BleakClient(address) as client:
            if not client.is_connected:
                # This is unlikely, as BleakClient raises an exception on failure.
                print(f"Error: Failed to connect to {device_name}.", file=sys.stderr, flush=True)
                return

            print(f"Success. Streaming data from {device_name}.", file=sys.stderr, flush=True)
            data_queue = asyncio.Queue()
            await client.start_notify(
                notify_uuid,
                lambda sender, data: notification_handler(sender, data, data_queue, device_name, client.address)
            )
            
            while True:
                yield await data_queue.get()

    except Exception as e:
        print(f"Error: Connection to {device_name} failed: {e}", file=sys.stderr, flush=True)