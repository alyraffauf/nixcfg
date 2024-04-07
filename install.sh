#!/bin/sh
# Copyright 2024 Aly Raffauf
#
# This program is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Automatically partitions drive and installs NixOS from a given flake,
# provided your flake includes a valid disko configuration.

# Check if an argument is provided
if [ $# -eq 0 ]; then
	echo "Error: Please provide a flake as an argument."
	exit 1
fi

# Construct the flake input
FLAKE_INPUT=$1

# Display a warning message
echo "Warning: Running this script will wipe the currently installed system."
read -p "Do you want to continue? (y/n): " answer

# Check the user's response
if [ "$answer" != "y" ]; then
	echo "Aborted."
	exit 0
fi

# Run the nix command with the updated flake input
sudo nix --experimental-features "nix-command flakes" run \
    github:nix-community/disko -- --mode disko --flake $FLAKE_INPUT

# Install NixOS with the updated flake input and root settings
sudo nixos-install --no-root-password --root /mnt --flake $FLAKE_INPUT
