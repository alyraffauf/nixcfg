#!/usr/bin/env bash
set -euo pipefail

readonly GITHUB_API_VERSION="Accept: application/vnd.github+json"

printUsage() {
  cat <<'EOF' >&2
Usage:
  pr_review_comment_reply.sh [-R OWNER/REPO] PR_NUMBER COMMENT_ID --body "TEXT"
  pr_review_comment_reply.sh [-R OWNER/REPO] PR_NUMBER COMMENT_ID --body-file path/to/body.txt

Replies to an existing inline PR review comment (REST).

Uses:
  POST /repos/{owner}/{repo}/pulls/{pull_number}/comments/{comment_id}/replies
EOF
}

parseArguments() {
  repository=""
  bodyContent=""
  bodyFilePath=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -R)
      repository="$2"
      shift 2
      ;;
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
    --)
      shift
      break
      ;;
    *)
      break
      ;;
    esac
  done

  if [[ $# -lt 2 ]]; then
    printUsage
    exit 2
  fi

  pullRequestNumber="$1"
  commentId="$2"
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

resolveRepository() {
  if [[ -z ${repository} ]]; then
    repository="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
  fi
  if [[ -z ${repository} ]]; then
    echo "Unable to determine repo. Pass -R OWNER/REPO or run inside a repo checkout." >&2
    exit 1
  fi

  repositoryOwner="${repository%/*}"
  repositoryName="${repository#*/}"
}

postReply() {
  gh api -X POST -H "${GITHUB_API_VERSION}" \
    "/repos/${repositoryOwner}/${repositoryName}/pulls/${pullRequestNumber}/comments/${commentId}/replies" \
    -f body="${bodyContent}"
}

main() {
  parseArguments "$@"
  loadBodyContent
  resolveRepository
  postReply
}

main "$@"
