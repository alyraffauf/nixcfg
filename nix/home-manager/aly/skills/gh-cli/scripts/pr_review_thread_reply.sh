#!/usr/bin/env bash
set -euo pipefail

printUsage() {
  cat <<'EOF' >&2
Usage:
  pr_review_thread_reply.sh THREAD_ID --body "TEXT"
  pr_review_thread_reply.sh THREAD_ID --body-file path/to/body.txt

Replies to a PR review thread (GraphQL).

THREAD_ID is the GraphQL node id for a PullRequestReviewThread (e.g. PRRT_...),
which you can fetch via:
  scripts/pr_feedback.sh -R OWNER/REPO PR_NUMBER | jq -r '.reviewThreads[] | select(.isResolved == false) | .id'
EOF
}

parseArguments() {
  if [[ $# -lt 1 ]]; then
    printUsage
    exit 2
  fi

  reviewThreadId="$1"
  shift

  bodyContent=""
  bodyFilePath=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --body)
      bodyContent="$2"
      shift 2
      ;;
    --body-file)
      bodyFilePath="$2"
      shift 2
      ;;
    -h | --help)
      printUsage
      exit 0
      ;;
    *)
      break
      ;;
    esac
  done
}

loadBodyContent() {
  if [[ -z ${bodyContent} && -n ${bodyFilePath} ]]; then
    if [[ ! -f ${bodyFilePath} ]]; then
      echo "Body file not found: ${bodyFilePath}" >&2
      exit 1
    fi
    bodyContent="$(cat "${bodyFilePath}")"
  fi
  if [[ -z ${bodyContent} ]]; then
    echo "Missing --body or --body-file" >&2
    exit 2
  fi
}

postReply() {
  local mutation

  # read returns 1 when it reaches the delimiter; "|| true" keeps set -e calm.
  read -r -d '' mutation <<'GRAPHQL' || true
mutation($threadId: ID!, $body: String!) {
  addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $threadId, body: $body}) {
    comment { id databaseId url }
  }
}
GRAPHQL

  gh api graphql -f query="${mutation}" \
    -F threadId="${reviewThreadId}" \
    -F body="${bodyContent}" \
    -q '.data.addPullRequestReviewThreadReply.comment'
}

main() {
  parseArguments "$@"
  loadBodyContent
  postReply
}

main "$@"
