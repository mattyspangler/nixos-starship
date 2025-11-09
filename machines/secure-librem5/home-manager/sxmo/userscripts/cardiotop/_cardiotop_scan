#!/usr/bin/env python
import asyncio
from bleak import BleakScanner

async def main():
    """
    Scans for BLE devices and prints them in a dmenu-friendly format.
    """
    found_devices = await BleakScanner.discover()
    for device in found_devices:
        if device.name:
            print(f"{device.address}\t{device.name}")

if __name__ == "__main__":
    asyncio.run(main())