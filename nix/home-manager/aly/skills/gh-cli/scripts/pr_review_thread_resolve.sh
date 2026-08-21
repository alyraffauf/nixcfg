#!/usr/bin/env bash
set -euo pipefail

printUsage() {
  cat <<'EOF' >&2
Usage:
  pr_review_thread_resolve.sh --yes THREAD_ID

Marks a PR review thread as resolved (GraphQL).

THREAD_ID is the GraphQL node id for a PullRequestReviewThread (e.g. PRRT_...).
This is a state change; --yes is required to proceed. Callers should ask the
user for explicit approval before passing --yes. Reopen with
pr_review_thread_unresolve.sh.
EOF
}

parseArguments() {
  isConfirmed=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --yes)
      isConfirmed=true
      shift
      ;;
    -h | --help)
      printUsage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      printUsage
      exit 2
      ;;
    *)
      break
      ;;
    esac
  done

  if [[ $# -ne 1 ]]; then
    printUsage
    exit 2
  fi

  reviewThreadId="$1"
}

requireConfirmation() {
  if [[ ${isConfirmed} != true ]]; then
    echo "Resolve review thread ${reviewThreadId} is a state change. Pass --yes only after explicit user approval." >&2
    exit 1
  fi
}

resolveThread() {
  local mutation

  # read returns 1 when it reaches the delimiter; "|| true" keeps set -e calm.
  read -r -d '' mutation <<'GRAPHQL' || true
mutation($threadId: ID!) {
  resolveReviewThread(input: {threadId: $threadId}) {
    thread { id isResolved }
  }
}
GRAPHQL

  gh api graphql -f query="${mutation}" -F threadId="${reviewThreadId}" -q '.data.resolveReviewThread.thread'
}

main() {
  parseArguments "$@"
  requireConfirmation
  resolveThread
}

main "$@"
