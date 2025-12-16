#!/bin/bash
# Installation script for HP OmniBook FH0xxx audio DSP
# This script sets up PipeWire/WirePlumber filter chain with bass enhancement and compression
# Installs system-wide (requires sudo)

set -e

echo "=== HP OmniBook FH0xxx Audio DSP ==="
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Step 1: Detecting your audio device..."
echo ""

# Try to detect the actual speaker device name
DETECTED_DEVICE=$(pw-dump 2>/dev/null | grep -o 'alsa_output\.pci-[^"]*Speaker[^"]*' | head -n1 || echo "")

if [ -n "$DETECTED_DEVICE" ]; then
  echo "✓ Detected speaker device: $DETECTED_DEVICE"
  DEFAULT_DEVICE="$DETECTED_DEVICE"
else
  echo "⚠ Could not auto-detect speaker device"
  DEFAULT_DEVICE="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
fi

echo ""
echo "Please verify your speaker device name."
echo "You can find it by running: pw-dump | grep -C 5 Speaker"
echo ""
read -r -p "Enter device name (or press Enter for '$DEFAULT_DEVICE'): " USER_DEVICE
DEVICE_NAME="${USER_DEVICE:-$DEFAULT_DEVICE}"

echo ""
read -p "Hide the raw speaker device? (Y/n): " -n 1 -r HIDE_RAW
echo ""
if [[ $HIDE_RAW =~ ^[Nn]$ ]]; then
  HIDE_PARENT="false"
else
  HIDE_PARENT="true"
fi

echo ""
echo "Step 2: Creating system configuration directory..."
sudo mkdir -p /etc/wireplumber/wireplumber.conf.d

echo ""
echo "Step 3: Installing omnibook-fh0xxx-filter-chain.json..."
sudo cp "$SCRIPT_DIR/omnibook-fh0xxx-filter-chain.json" /etc/wireplumber/wireplumber.conf.d/omnibook-fh0xxx-filter-chain.json

# Substitute placeholders in filter-chain.json
sudo sed -i "s|@DEVICE_NAME@|$DEVICE_NAME|g" /etc/wireplumber/wireplumber.conf.d/omnibook-fh0xxx-filter-chain.json
echo "✓ Installed omnibook-fh0xxx-filter-chain.json with device: $DEVICE_NAME"

echo ""
echo "Step 4: Installing WirePlumber configuration..."
sudo cp "$SCRIPT_DIR/99-omnibook.conf" /etc/wireplumber/wireplumber.conf.d/99-omnibook.conf

# Substitute placeholders in WirePlumber config
sudo sed -i "s|@DEVICE_NAME@|$DEVICE_NAME|g" /etc/wireplumber/wireplumber.conf.d/99-omnibook.conf
sudo sed -i "s|@FILTER_PATH@|/etc/wireplumber/wireplumber.conf.d/omnibook-fh0xxx-filter-chain.json|g" /etc/wireplumber/wireplumber.conf.d/99-omnibook.conf
sudo sed -i "s|@HIDE_PARENT@|$HIDE_PARENT|g" /etc/wireplumber/wireplumber.conf.d/99-omnibook.conf
echo "✓ Installed 99-omnibook.conf with device: $DEVICE_NAME (hide-parent: $HIDE_PARENT)"

echo ""
echo "Step 5: Restarting PipeWire and WirePlumber..."
systemctl --user restart pipewire pipewire-pulse wireplumber

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "Important notes:"
echo "1. Set your speakers to 100% volume (the filter chain will control volume)"
echo "2. You may need to select 'OmniBook Speakers' as your default output device"
echo "3. Raw speaker device hidden: $HIDE_PARENT"
echo "4. If you experience issues, check: journalctl --user -u wireplumber -f"
echo ""
echo "Configuration files installed:"
echo "  - /etc/wireplumber/wireplumber.conf.d/omnibook-fh0xxx-filter-chain.json"
echo "  - /etc/wireplumber/wireplumber.conf.d/99-omnibook.conf"
echo ""
echo "To uninstall: sudo rm /etc/wireplumber/wireplumber.conf.d/{omnibook-fh0xxx-filter-chain.json,99-omnibook.conf}"
echo "Then restart pipewire/wireplumber."
echo ""
