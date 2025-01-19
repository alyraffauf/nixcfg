#!/usr/bin/env bash

set -euo pipefail

# Initialize variables
ALEJANDRA_ARGS=()
MDFORMAT_ARGS=()
SHFMT_ARGS=("-i" "4")

# Check if "-c" is present in any argument
CHECK_MODE=false
for arg in "$@"; do
    if [ "$arg" = "-c" ]; then
        CHECK_MODE=true
        break
    fi
done

# Adjust arguments based on CHECK_MODE
if $CHECK_MODE; then
    ALEJANDRA_ARGS+=("-c")
    MDFORMAT_ARGS+=(--check)
    SHFMT_ARGS+=("-d") # Add -d for diff mode (no -w)
else
    SHFMT_ARGS+=("-w") # Add -w for writing changes
fi

# Format all markdown files
find . -type f -name "*.md" -exec mdformat "${MDFORMAT_ARGS[@]}" {} +

# Format all shell files
find . -type f -name "*.sh" -exec shfmt "${SHFMT_ARGS[@]}" {} +

# Format all nix files
find . -type f -name "*.nix" -exec alejandra "${ALEJANDRA_ARGS[@]}" {} +
