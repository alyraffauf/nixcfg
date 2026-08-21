#!/usr/bin/env bash
set -euo pipefail

echo "== gh version =="
gh --version
echo

echo "== gh auth status =="
if ! gh auth status; then
  echo "gh auth status failed (not logged in?)" >&2
fi
echo

echo "== repo context (best effort) =="
if gh repo view --json nameWithOwner,url -q '"\(.nameWithOwner)\t\(.url)"' >/dev/null 2>&1; then
  gh repo view --json nameWithOwner,url -q '"\(.nameWithOwner)\t\(.url)"'
else
  echo "Not in a GitHub repo checkout (or no access to infer repo from cwd)."
fi
