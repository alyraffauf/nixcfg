#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-only
# Helper functions for installing packages from COPR repositories

set -euo pipefail

# Install packages from a COPR repo in an isolated manner
# This function enables a COPR repo, installs the specified packages, then disables the repo
# Usage: copr_install_isolated "owner/repo" "package1" "package2" ...
copr_install_isolated() {
    if [ $# -lt 2 ]; then
        echo "ERROR: copr_install_isolated requires at least 2 arguments: repo_name and at least one package" >&2
        echo "Usage: copr_install_isolated \"owner/repo\" \"package1\" [\"package2\" ...]" >&2
        return 1
    fi

    local repo_name="$1"
    shift
    local packages=("$@")

    echo "Installing packages from COPR repo: $repo_name"
    echo "Packages: ${packages[*]}"

    # Enable the COPR repository
    dnf5 -y copr enable "$repo_name"

    # Install the packages from the COPR repository
    dnf5 -y --repo="copr:copr.fedorainfracloud.org:${repo_name/\//:}" install "${packages[@]}"

    # Disable the COPR repository to keep it isolated
    dnf5 -y copr disable "$repo_name"

    echo "Successfully installed packages from $repo_name"
}
