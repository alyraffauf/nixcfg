#!/usr/bin/env bash

set -euo pipefail

# Initialize variables
ALEJANDRA_ARGS=()
DEADNIX_ARGS=()
PRETTIER_ARGS=()
RUBOCOP_ARGS=()
SHFMT_ARGS=("-i" "2")
STATIX_ARGS=()
GOPLS_ARGS=()

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
  DEADNIX_ARGS+=("--fail")
  PRETTIER_ARGS+=("--check")
  SHFMT_ARGS+=("-d") # Use diff mode (don't write changes)
  STATIX_ARGS+=("check")
else
  DEADNIX_ARGS+=("--edit")
  RUBOCOP_ARGS+=("-A" "--disable-uncorrectable")
  PRETTIER_ARGS+=("--write")
  SHFMT_ARGS+=("-w")
  STATIX_ARGS+=("fix")
  GOPLS_ARGS+=("-w")
fi

# Lint all nix files
statix "${STATIX_ARGS[@]}"

# Remove unused code in nix files
deadnix "${DEADNIX_ARGS[@]}"

# Format all nix files
find . -type f -name "*.nix" -exec alejandra "${ALEJANDRA_ARGS[@]}" {} +

# Format all markdown files using Prettier
find . -type f -name "*.md" -exec prettier "${PRETTIER_ARGS[@]}" {} +

# Format all yaml files using Prettier
find . -type f -name "*.yml" -exec prettier "${PRETTIER_ARGS[@]}" {} +

# Format all json files using Prettier
find . -type f -name "*.json" -exec prettier "${PRETTIER_ARGS[@]}" {} +

# Format all ruby files
find . -type f -name "*.rb" -exec rubocop "${RUBOCOP_ARGS[@]}" {} +

# Format all shell files
find . -type f -name "*.sh" -exec shfmt "${SHFMT_ARGS[@]}" {} +

# Format go files using gopls
if $CHECK_MODE; then
  failed=0
  # -print0 / read -d '' protects against spaces in filenames
  while IFS= read -r -d '' file; do
    # diff exits 1 when files differ, 0 when identical
    if ! gopls format "$file" | diff -u "$file" - >/dev/null; then
      echo "✗ $file needs formatting"
      failed=1
    fi
  done < <(find . -type f -name '*.go' -print0)

  if ((failed)); then
    exit 1
  fi
else
  find . -type f -name '*.go' -exec gopls format "${GOPLS_ARGS[@]}" {} +
fi
