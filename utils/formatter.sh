#!/usr/bin/env bash

set -euo pipefail

# Initialize variables
ALEJANDRA_ARGS=()
PRETTIER_ARGS=()
RUBOCOP_ARGS=()
SHFMT_ARGS=("-i" "2")

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
  PRETTIER_ARGS+=("--check")
  SHFMT_ARGS+=("-d") # Use diff mode (don't write changes)
else
  RUBOCOP_ARGS+=("-A" "--disable-uncorrectable")
  PRETTIER_ARGS+=("--write")
  SHFMT_ARGS+=("-w") # Write changes
fi

# Format all nix files
find . -type f -name "*.nix" -exec alejandra "${ALEJANDRA_ARGS[@]}" {} +

# Format all markdown files using Prettier
find . -type f -name "*.md" -exec prettier "${PRETTIER_ARGS[@]}" {} +

# Format all ruby files
find . -type f -name "*.rb" -exec rubocop "${RUBOCOP_ARGS[@]}" {} +

# Format all shell files
find . -type f -name "*.sh" -exec shfmt "${SHFMT_ARGS[@]}" {} +
