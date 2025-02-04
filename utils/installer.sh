#!/usr/bin/env bash

set -euo pipefail

read -rp "Which host are you installing? " HOST

FLAKE=github:alyraffauf/nixcfg
FLAKE_NIXOS="$FLAKE"#"$HOST"

echo "Installing from $FLAKE_NIXOS"

echo "Warning: Running this script will wipe the currently installed system."
read -rp "Do you want to continue? (y/n): " answer

if [ "$answer" != "y" ]; then
  echo "Aborted."
  exit 0
fi

# Build the NixOS configuration first to use substituters and check evaluation.
sudo nix --accept-flake-config --experimental-features "nix-command flakes" \
  build "$FLAKE"#nixosConfigurations."$HOST".config.system.build.toplevel

# Partition the disk with disk.
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- --mode disko --flake "$FLAKE_NIXOS"

# Install NixOS to the partitioned disk.
sudo nixos-install --no-root-password --root /mnt --flake "$FLAKE_NIXOS"

echo "Installation complete."
echo "Warning: If you're using lanzaboote, you need to nixos-enter the installed system, generate your keys, and rebuild the system before rebooting."
