#!/usr/bin/env bash

# Script to copy Intel ISH firmware file to the correct location
# Enables auto-rotate and other sensors.
# Not for use on NixOS, here for documentation purposes.
# This copies ishC_0207.bin to /lib/firmware/intel/ish/ish_lnlm_12128606.bin

set -e # Exit on any error

SOURCE_FILE="ishC_0207.bin"
DEST_DIR="/lib/firmware/intel/ish"
DEST_FILE="$DEST_DIR/ish_lnlm_12128606.bin"

echo "Intel ISH Firmware Copy Script"
echo "=============================="

# Check if source file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: Source file '$SOURCE_FILE' not found in current directory"
  echo "Please ensure the file is in the same directory as this script"
  exit 1
fi

echo "Source file: $SOURCE_FILE"
echo "Destination: $DEST_FILE"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (use sudo)"
  echo "Usage: sudo $0"
  exit 1
fi

# Create destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
  echo "Creating directory: $DEST_DIR"
  mkdir -p "$DEST_DIR"
fi

# Copy the file
echo "Copying firmware file..."
cp "$SOURCE_FILE" "$DEST_FILE"

# Set appropriate permissions
chmod 644 "$DEST_FILE"

# Verify the copy was successful
if [ -f "$DEST_FILE" ]; then
  echo "Success! Firmware file copied to: $DEST_FILE"
  echo "File size: $(stat -c%s "$DEST_FILE") bytes"
  echo "Permissions: $(stat -c%a "$DEST_FILE")"
else
  echo "Error: Failed to copy firmware file"
  exit 1
fi

# Regenerate initramfs to include the new firmware
echo "Regenerating initramfs..."
dracut -f

echo "Done! Initramfs has been regenerated with the new firmware."
