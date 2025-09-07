#!/usr/bin/env python3
"""
HP OmniBook Haptic Touchpad Controller

This script controls the haptic feedback intensity on HP OmniBook FH0xxx series laptops.
It communicates with the touchpad via HID raw device interface.
"""

import fcntl
import struct
import argparse
import os
import glob
import logging

# HID Device Constants
REPORT_ID_INTENSITY = 0x37
VENDOR_ID = '06CB'  # HP Inc.
PRODUCT_ID = 'CFD2'  # OmniBook haptic touchpad
HIDIOCSFEATURE_9 = 0xC0094806  # HID ioctl for 9-byte feature report

# Valid intensity levels (0 = off, 100 = maximum)
VALID_INTENSITIES = [0, 25, 50, 75, 100]
HID_REPORT_SIZE = 9

# Paths
HIDRAW_PATTERN = "/dev/hidraw*"
UEVENT_PATH_TEMPLATE = "/sys/class/hidraw/hidraw{}/device/uevent"


def find_haptic_device() -> str:
    """Find the haptic touchpad HID device path."""
    logging.debug(f"Searching for device {VENDOR_ID}:{PRODUCT_ID}")

    for hidraw in sorted(glob.glob(HIDRAW_PATTERN)):
        hidraw_num = hidraw.split('hidraw')[1]
        uevent_path = UEVENT_PATH_TEMPLATE.format(hidraw_num)

        try:
            if not os.path.isfile(uevent_path):
                continue

            with open(uevent_path, 'r') as f:
                uevent_content = f.read()

            # More precise matching to avoid false positives
            lines = uevent_content.strip().split('\n')
            hid_id = None
            for line in lines:
                if line.startswith('HID_ID='):
                    hid_id = line.split('=', 1)[1]
                    break

            if hid_id:
                # Parse HID_ID format: XXXX:VVVVVVVV:PPPPPPPP
                # Example: 0018:000006CB:0000CFD2
                parts = hid_id.split(':')
                if len(parts) >= 3:
                    vendor_part = parts[1][-4:]  # Last 4 chars of vendor
                    product_part = parts[2][-4:]  # Last 4 chars of product

                    if vendor_part.upper() == VENDOR_ID and product_part.upper() == PRODUCT_ID:
                        logging.info(f"Found haptic device: {hidraw}")
                        return hidraw

        except (OSError, IOError) as e:
            logging.debug(f"Failed to read {uevent_path}: {e}")

    raise FileNotFoundError(f"Haptic touchpad device not found (looking for {VENDOR_ID}:{PRODUCT_ID})")


def send_force_intensity(path: str, intensity: int) -> None:
    """Send haptic force intensity command to the device."""
    if intensity not in VALID_INTENSITIES:
        raise ValueError(f"Invalid intensity {intensity}. Must be one of {VALID_INTENSITIES}")

    if not os.path.exists(path):
        raise FileNotFoundError(f"Device path {path} does not exist")

    report = struct.pack("BB", REPORT_ID_INTENSITY, intensity)

    try:
        with open(path, "rb+", buffering=0) as f:
            buf = report.ljust(HID_REPORT_SIZE, b"\x00")
            fcntl.ioctl(f, HIDIOCSFEATURE_9, buf)
            logging.info(f"Successfully set haptic intensity to {intensity}")
    except PermissionError:
        raise PermissionError(f"Permission denied accessing {path}. Try running with sudo.")
    except OSError as e:
        raise OSError(f"Failed to communicate with device {path}: {e}")


def list_haptic_devices() -> None:
    """List all potential haptic devices found on the system."""
    devices = []
    for hidraw in sorted(glob.glob(HIDRAW_PATTERN)):
        hidraw_num = hidraw.split('hidraw')[1]
        uevent_path = UEVENT_PATH_TEMPLATE.format(hidraw_num)
        try:
            with open(uevent_path, 'r') as f:
                content = f.read()
                if VENDOR_ID in content:
                    devices.append(hidraw)
        except (OSError, IOError):
            continue

    if devices:
        print("Found HP devices:")
        for device in devices:
            print(f"  {device}")
    else:
        print("No HP HID devices found")


def setup_logging(verbose: bool = False) -> None:
    """Configure logging based on verbosity level."""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format='%(levelname)s: %(message)s'
    )


def main() -> int:
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Control haptic feedback intensity on HP OmniBook touchpad",
        epilog="Example: %(prog)s 50  # Set intensity to 50%"
    )
    parser.add_argument(
        "intensity",
        type=int,
        choices=VALID_INTENSITIES,
        nargs='?',
        help=f"Haptic intensity level: {', '.join(map(str, VALID_INTENSITIES))} (0=off, 100=max)"
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output"
    )
    parser.add_argument(
        "--device",
        help="Specify device path directly (bypasses auto-detection)"
    )
    parser.add_argument(
        "--list-devices",
        action="store_true",
        help="List all potential HP haptic devices and exit"
    )

    args = parser.parse_args()
    setup_logging(args.verbose)

    if args.list_devices:
        list_haptic_devices()
        return 0

    if args.intensity is None:
        parser.error("intensity is required when not using --list-devices")

    try:
        if args.device:
            device_path = args.device
            logging.info(f"Using specified device: {device_path}")
        else:
            device_path = find_haptic_device()

        send_force_intensity(device_path, args.intensity)
        return 0

    except (FileNotFoundError, PermissionError, ValueError, OSError) as e:
        logging.error(str(e))
        return 1
    except KeyboardInterrupt:
        logging.info("Operation cancelled by user")
        return 1
    except Exception as e:
        logging.error(f"Unexpected error: {e}")
        return 1


if __name__ == "__main__":
    exit(main())
