#!/usr/bin/env bash
# World's stupidest NixOS deployment script.

set -euo pipefail

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
command -v nixos-rebuild >/dev/null || {
  echo -e "${RED}Error: 'nixos-rebuild' command not found.${NC}"
  exit 1
}
command -v jq >/dev/null || {
  echo -e "${RED}Error: 'jq' command not found. Please install jq.${NC}"
  exit 1
}

echo -e "[deployer] ${BLUE}FLAKE: ${FLAKE}${NC}"
echo -e "[deployer] ${BLUE}OPERATION: ${OPERATION}${NC}"

# Load deployments from deployments.nix using nix eval (output as JSON)
echo -e "[deployer] ${BLUE}Beginning deployments...${NC}"
deployments_json=$(nix eval --json -f "$DEPLOYMENTS")

for host in $(echo "$deployments_json" | jq -r 'keys[]' | sort); do
  output=$(echo "$deployments_json" | jq -r --arg host "$host" '.[$host].output')
  hostname=$(echo "$deployments_json" | jq -r --arg host "$host" '.[$host].hostname')
  remoteBuild=$(echo "$deployments_json" | jq -r --arg host "$host" '.[$host].remoteBuild')
  user=$(echo "$deployments_json" | jq -r --arg host "$host" '.[$host].user')

  # Determine build mode.
  if [[ "$remoteBuild" == "true" ]]; then
    build_host_option="$user@$hostname"
  else
    build_host_option="localhost"
  fi

  echo -e "[deployer] ${YELLOW}Deploying ${FLAKE}#${output} to ${user}@${hostname} (building on ${build_host_option})...${NC}"

  nixos-rebuild "$OPERATION" \
    --build-host "$build_host_option" \
    --target-host "$user@$hostname" \
    --flake "$FLAKE#$output" \
    --fast

  echo -e "[deployer] ${GREEN}Successfully deployed ${FLAKE}#${output} to ${user}@${hostname}.${NC}"
done

echo -e "[deployer] ${BLUE}Deployments complete.${NC}"
