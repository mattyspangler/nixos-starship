"""
Device module for the Polar Verity Sense.
"""

from .common import ble_stream_manager

# Standard Bluetooth Service and Characteristic UUIDs
HEART_RATE_MEASUREMENT_CHARACTERISTIC_UUID = "00002a37-0000-1000-8000-00805f9b34fb"

# Compatible device models.
COMPATIBLE_MODELS = ["Polar Verity Sense", "Polar Sense"]
DEFAULT_PROFILE_TEMPLATE = "polar_default.json"

def polar_notification_handler(sender, data, queue, device_name, address):
    """Handles incoming heart rate data from a Polar device."""
    heart_rate = data[1]
    # Put a simple, flat dictionary onto the queue.
    # A flat dictionary is easy for any consumer (TUI, conky, etc.) to parse.
    queue.put_nowait({
        "device_name": device_name,
        "address": address,
        "heart_rate": heart_rate
    })

async def get_device_stream(profile: dict):
    """Factory function to stream data from a Polar device."""
    async for data in ble_stream_manager(
        profile=profile,
        compatible_models=COMPATIBLE_MODELS,
        notify_uuid=HEART_RATE_MEASUREMENT_CHARACTERISTIC_UUID,
        notification_handler=polar_notification_handler
    ):
        yield data
