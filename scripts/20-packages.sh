#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-only
# Package installation script for Fedora-based container images
# This script reads packages.json and installs/removes packages accordingly

set -euo pipefail

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/copr_helpers.sh"

# Set default context path if not provided
CTX_PATH="${CTX_PATH:-/ctx}"
PACKAGES_JSON="${CTX_PATH}/packages.json"

# Determine IMAGE_NAME and FEDORA_MAJOR_VERSION from environment or defaults
IMAGE_NAME="${IMAGE_NAME:-kinoite}"
FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"

echo "Installing packages for image: ${IMAGE_NAME} (Fedora ${FEDORA_MAJOR_VERSION})"

# Lock plasma-desktop version to prevent unwanted updates
dnf5 versionlock add plasma-desktop

# Validate packages.json before attempting to parse it
# This ensures builds fail fast if the JSON is malformed
if ! jq empty "${PACKAGES_JSON}" 2>/dev/null; then
    echo "ERROR: packages.json contains syntax errors and cannot be parsed" >&2
    echo "Please fix the JSON syntax before building" >&2
    exit 1
fi

# Build list of all packages requested for inclusion
# The jq query:
# 1. Gets packages from .all.include.all
# 2. Gets packages from .all.include.<IMAGE_NAME>
# 3. Gets packages from .<FEDORA_MAJOR_VERSION>.include.all
# 4. Gets packages from .<FEDORA_MAJOR_VERSION>.include.<IMAGE_NAME>
# 5. Sorts and deduplicates the combined list
readarray -t INCLUDED_PACKAGES < <(jq -r "[(.all.include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".include | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" "${PACKAGES_JSON}")

# Install Packages
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    echo "Installing ${#INCLUDED_PACKAGES[@]} packages..."
    dnf5 -y install \
        "${INCLUDED_PACKAGES[@]}"
else
    echo "No packages to install."
fi

# Build list of all packages requested for exclusion
# The jq query follows the same pattern as INCLUDED_PACKAGES but for .exclude
readarray -t EXCLUDED_PACKAGES < <(jq -r "[(.all.exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[]), \
                             (select(.\"$FEDORA_MAJOR_VERSION\" != null).\"$FEDORA_MAJOR_VERSION\".exclude | (.all, select(.\"$IMAGE_NAME\" != null).\"$IMAGE_NAME\")[])] \
                             | sort | unique[]" "${PACKAGES_JSON}")

# Filter excluded packages to only those that are actually installed
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    INSTALLED_EXCLUDED=()
    for pkg in "${EXCLUDED_PACKAGES[@]}"; do
        if rpm -q "$pkg" &>/dev/null; then
            INSTALLED_EXCLUDED+=("$pkg")
        fi
    done
    EXCLUDED_PACKAGES=("${INSTALLED_EXCLUDED[@]}")
fi

# Remove any excluded packages which are still present on image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    echo "Removing ${#EXCLUDED_PACKAGES[@]} packages..."
    dnf5 -y remove \
        "${EXCLUDED_PACKAGES[@]}"
else
    echo "No packages to remove."
fi

# Install tailscale package from their repo
echo "Installing tailscale from official repo..."
dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 config-manager setopt tailscale-stable.enabled=0
dnf5 -y install --enablerepo='tailscale-stable' tailscale

# Install packages from COPR repositories
echo "Installing packages from COPR repositories..."

# Uncomment when ghostty is available
# copr_install_isolated "scottames/ghostty" "ghostty"

copr_install_isolated "lizardbyte/beta" \
    "sunshine"

copr_install_isolated "ublue-os/packages" \
    "krunner-bazaar"

# TODO: remove me on next flatpak release when preinstall landed in Fedora
echo "Installing flatpak from ublue-os/flatpak-test COPR..."
dnf5 -y copr enable ublue-os/flatpak-test
dnf5 -y copr disable ublue-os/flatpak-test
dnf5 -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak flatpak
dnf5 -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak-libs flatpak-libs
dnf5 -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test swap flatpak-session-helper flatpak-session-helper
dnf5 -y --repo=copr:copr.fedorainfracloud.org:ublue-os:flatpak-test install flatpak-debuginfo flatpak-libs-debuginfo flatpak-session-helper-debuginfo

echo "Package installation completed successfully!"
