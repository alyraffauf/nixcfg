#!/usr/bin/env bash

set -euo pipefail

read -rp "Which host are you installing? " HOST

FLAKE=github:alyraffauf/nixcfg#$HOST
echo "Installing from $FLAKE"

echo "Warning: Running this script will wipe the currently installed system."
read -rp "Do you want to continue? (y/n): " answer

if [ "$answer" != "y" ]; then
    echo "Aborted."
    exit 0
fi

sudo nix --experimental-features "nix-command flakes" run \
    github:nix-community/disko -- --mode disko --flake "$FLAKE"

# Install NixOS with the updated flake input and root settings
sudo nixos-install --no-root-password --root /mnt --flake "$FLAKE"
