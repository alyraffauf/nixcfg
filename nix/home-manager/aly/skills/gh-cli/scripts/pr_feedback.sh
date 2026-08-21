#!/usr/bin/env bash
set -euo pipefail

readonly GITHUB_API_VERSION="Accept: application/vnd.github+json"
readonly REST_PAGE_SIZE=100
readonly GRAPHQL_PAGE_LIMIT=100

printUsage() {
  cat <<'EOF' >&2
Usage:
  pr_feedback.sh [-R OWNER/REPO] PR_NUMBER

Outputs a single JSON object containing:
- pr: core PR metadata + reviews + PR (issue) comments
- reviewComments: inline review comments (REST: list review comments)
- reviewThreads: review threads (GraphQL: includes resolved/outdated state)

Notes:
- Requires: gh, jq
- Defaults repo from current directory if -R is omitted
- GraphQL reviewThreads fetch is limited to first 100 threads/comments (no pagination)
EOF
}

parseArguments() {
  repository=""
  while getopts ":R:h" option; do
    case "${option}" in
    R) repository="${OPTARG}" ;;
    h)
      printUsage
      exit 0
      ;;
    \?)
      printUsage
      exit 2
      ;;
    *)
      printUsage
      exit 2
      ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ $# -ne 1 ]]; then
    printUsage
    exit 2
  fi

  pullRequestNumber="$1"
}

requireCommands() {
  if ! command -v gh >/dev/null 2>&1; then
    echo "gh is required" >&2
    exit 1
  fi
  if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required" >&2
    exit 1
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

fetchPullRequestData() {
  local outputFile="$1"

  gh pr view -R "${repository}" "${pullRequestNumber}" \
    --json number,title,url,state,author,createdAt,updatedAt,baseRefName,headRefName,mergeable,mergeStateStatus,reviewDecision,comments,reviews \
    >"${outputFile}"
}

fetchInlineReviewComments() {
  local outputFile="$1"

  gh api --paginate -H "${GITHUB_API_VERSION}" \
    "/repos/${repositoryOwner}/${repositoryName}/pulls/${pullRequestNumber}/comments?per_page=${REST_PAGE_SIZE}" \
    >"${outputFile}"
}

fetchReviewThreads() {
  local outputFile="$1"
  local query

  # read returns 1 when it reaches the delimiter; "|| true" keeps set -e calm.
  read -r -d '' query <<GRAPHQL || true
query(\$owner:String!, \$name:String!, \$number:Int!) {
  repository(owner: \$owner, name: \$name) {
    pullRequest(number: \$number) {
      id
      number
      url
      reviewThreads(first: ${GRAPHQL_PAGE_LIMIT}) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          startLine
          diffSide
          startDiffSide
          viewerCanReply
          viewerCanResolve
          comments(first: ${GRAPHQL_PAGE_LIMIT}) {
            nodes {
              id
              databaseId
              url
              createdAt
              author { login }
              body
            }
          }
        }
      }
    }
  }
}
GRAPHQL

  gh api graphql -f query="${query}" \
    -F owner="${repositoryOwner}" \
    -F name="${repositoryName}" \
    -F number="${pullRequestNumber}" \
    >"${outputFile}"
}

warnIfTruncated() {
  local label="$1"
  local filePath="$2"
  local limit="$3"
  local selector="${4:-.}"
  local count

  count="$(jq -r "${selector} | length" "${filePath}" 2>/dev/null || echo 0)"
  if [[ ${count} -ge ${limit} ]]; then
    echo "Warning: ${label} returned ${count} items (limit ${limit}); results may be truncated." >&2
  fi
}

emitTruncationWarnings() {
  # GraphQL reviewThreads: fetched with `first: GRAPHQL_PAGE_LIMIT`, no pagination.
  warnIfTruncated "review threads" "${reviewThreadsFile}" "${GRAPHQL_PAGE_LIMIT}" \
    '.data.repository.pullRequest.reviewThreads.nodes'

  # Per-thread comments are also capped at `first: GRAPHQL_PAGE_LIMIT`.
  # Warn only when a single thread hits the cap; summing across threads
  # would false-positive on any active PR.
  local maxThreadComments
  maxThreadComments="$(jq -r '
    [(.data.repository.pullRequest.reviewThreads.nodes // [])[]
     | ((.comments.nodes // []) | length)]
    | if length == 0 then 0 else max end' "${reviewThreadsFile}" 2>/dev/null || echo 0)"
  if [[ ${maxThreadComments} -ge ${GRAPHQL_PAGE_LIMIT} ]]; then
    echo "Warning: at least one review thread has ${maxThreadComments} comments (limit ${GRAPHQL_PAGE_LIMIT}); thread comments may be truncated." >&2
  fi

  # REST inline comments use `--paginate` (all pages), so a high count
  # does not indicate truncation; no warning needed.

  echo "Note: PR comments/reviews in 'pr' come from 'gh pr view' and are not paginated; large PRs may omit some." >&2
}

assembleOutput() {
  jq -n \
    --arg repository "${repository}" \
    --arg pullRequestNumber "${pullRequestNumber}" \
    --slurpfile pullRequest "${pullRequestFile}" \
    --slurpfile reviewComments "${reviewCommentsFile}" \
    --slurpfile reviewThreads "${reviewThreadsFile}" \
    '{
      repo: $repository,
      prNumber: ($pullRequestNumber | tonumber),
      pr: $pullRequest[0],
      reviewComments: $reviewComments[0],
      reviewThreads: $reviewThreads[0].data.repository.pullRequest.reviewThreads.nodes
    }'
}

main() {
  parseArguments "$@"
  requireCommands
  resolveRepository

  temporaryDirectory="$(mktemp -d)"
  cleanup() { rm -rf "${temporaryDirectory}"; }
  trap cleanup EXIT

  pullRequestFile="${temporaryDirectory}/pull-request.json"
  reviewCommentsFile="${temporaryDirectory}/review-comments.json"
  reviewThreadsFile="${temporaryDirectory}/review-threads.json"

  fetchPullRequestData "${pullRequestFile}"
  fetchInlineReviewComments "${reviewCommentsFile}"
  fetchReviewThreads "${reviewThreadsFile}"

  emitTruncationWarnings
  assembleOutput
}

main "$@"
