# Package Management Scripts

This directory contains scripts for managing packages in Fedora-based container images (e.g., Silverblue, Kinoite).

## Files

### `packages.json`
Located in the repository root, this file defines which packages to install and remove for different image variants.

Structure:
- `all.include.all`: Packages to install on all images
- `all.include.<image-name>`: Packages specific to an image variant (e.g., `kinoite`, `silverblue`)
- `all.exclude.<image-name>`: Packages to remove from an image variant

### `copr_helpers.sh`
Helper functions for working with COPR repositories.

**Functions:**
- `copr_install_isolated`: Installs packages from a COPR repository in an isolated manner (enables repo, installs packages, disables repo)

**Usage:**
```bash
source scripts/copr_helpers.sh
copr_install_isolated "owner/repo-name" "package1" "package2"
```

### `20-packages.sh`
Main package installation script that:
1. Locks `plasma-desktop` version
2. Validates `packages.json` syntax
3. Installs packages listed in `packages.json` based on `IMAGE_NAME` and `FEDORA_MAJOR_VERSION`
4. Removes excluded packages
5. Installs additional packages from external repos (Tailscale, COPR repos)

**Environment Variables:**
- `IMAGE_NAME`: Image variant (default: `kinoite`)
- `FEDORA_MAJOR_VERSION`: Fedora version (default: `41`)
- `CTX_PATH`: Path to context directory containing packages.json (default: `/ctx`)

**Usage:**
```bash
# With defaults (kinoite, Fedora 41)
./scripts/20-packages.sh

# With custom image and version
IMAGE_NAME=silverblue FEDORA_MAJOR_VERSION=40 ./scripts/20-packages.sh

# In a container build context
CTX_PATH=/workspace IMAGE_NAME=kinoite ./scripts/20-packages.sh
```

## Container Build Integration

These scripts are designed to be used in container image builds (e.g., with BlueBuild or Universal Blue). In a Containerfile:

```dockerfile
COPY packages.json /ctx/packages.json
COPY scripts /tmp/scripts
RUN /tmp/scripts/20-packages.sh
```

## Requirements

- `dnf5`: DNF package manager (version 5)
- `jq`: JSON processor for parsing packages.json
- `rpm`: RPM package manager for querying installed packages

## License

SPDX-License-Identifier: GPL-3.0-only
