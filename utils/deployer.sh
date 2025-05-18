#!/usr/bin/env bash
# NixOS deployer — build all, then deploy sequentially
# (positional flake syntax; parse JSON for outputs.out)

set -euo pipefail
IFS=$'\n\t'

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FLAKE="${FLAKE:-.}"
OPERATION="${OPERATION:-test}" # Options: "switch", "boot", "test", etc.
DEPLOYMENTS="${DEPLOYMENTS:-deployments.nix}"

# Ensure required commands are available.
for cmd in nix jq ssh; do
  command -v "$cmd" &>/dev/null || {
    echo -e "${RED}[deployer] Error: '$cmd' command not found.${NC}"
    exit 1
  }
done

echo -e "[deployer] ${BLUE}FLAKE: ${FLAKE}${NC}"
echo -e "[deployer] ${BLUE}OPERATION: ${OPERATION}${NC}"
echo -e "[deployer] ${BLUE}DEPLOYMENTS: ${DEPLOYMENTS}${NC}"

# Read deployments JSON once
HOSTS_JSON="$(nix eval --json -f "$DEPLOYMENTS")"
mapfile -t HOSTS < <(printf '%s\n' "$HOSTS_JSON" | jq -r 'keys[]')

# Phase 1: Build all closures
declare -A OUT_PATHS
echo -e "[deployer] ${BLUE}Building...${NC}"

for host in "${HOSTS[@]}"; do
  echo -e "[deployer] ${YELLOW}Building nixosConfigurations.${host}.config.system.build.toplevel...${NC}"

  # Build, printing JSON to stdout; warnings go to stderr
  out=$(nix build \
    --no-link \
    --json \
    ".#nixosConfigurations.${host}.config.system.build.toplevel" \
    2>/dev/null \
    | jq -r '.[0].outputs.out')

  OUT_PATHS["$host"]="$out"
  echo -e "[deployer] ${GREEN}✔ Built: ${out}${NC}"
done

echo -e "[deployer] ${GREEN}✔ All builds complete.${NC}"

# Phase 2: Copy & activate sequentially
echo -e "[deployer] ${BLUE}Deploying...${NC}"

for host in "${HOSTS[@]}"; do
  host_json=$(printf '%s\n' "$HOSTS_JSON" | jq --arg h "$host" '.[$h]')
  hostname=$(printf '%s\n' "$host_json" | jq -r '.hostname')
  user=$(printf '%s\n' "$host_json" | jq -r '.user')
  target="${user}@${hostname}"
  out="${OUT_PATHS[$host]}"

  echo -e "[deployer] ${YELLOW}Deploying to ${target}...${NC}"

  # Copy the closure
  nix copy --to "ssh://${target}" "$out"

  # Activate remotely
  # shellcheck disable=SC2029  # local expansion is intended
  ssh "$target" "sudo '$out/bin/switch-to-configuration' '$OPERATION'"

  echo -e "[deployer] ${GREEN}✔ Deployed to ${target}.${NC}"
done

echo -e "[deployer] ${GREEN}✔ All deployments complete.${NC}"
