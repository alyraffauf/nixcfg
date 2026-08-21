# GitHub `gh` CLI command reference

A command-first cookbook. Prefer first-class `gh <noun> <verb>` commands and machine-readable output (`--json` + `--jq`). Use `gh api` only when there is no first-class command. For exhaustive flag/field lists run `gh <command> --help`.

## Contents

- [Conventions](#conventions)
- [Auth and identity](#auth-and-identity)
- [Repo targeting and discovery](#repo-targeting-and-discovery)
- [Output formatting](#output-formatting)
- [Cheatsheet](#cheatsheet)
- [PR review feedback workflow](#pr-review-feedback-workflow)
- [`gh api` fallback](#gh-api-fallback-rest--graphql)

## Conventions

- Always prefer explicit repo targeting with `-R OWNER/REPO` unless you have confirmed the current directory’s repo via `gh repo view --json nameWithOwner -q .nameWithOwner`.
- Prefer `--json ... -q ...` over table output.
- When acting on an issue/PR by number, first list candidates and confirm the number — don't guess.
- Confirm before creating/closing/merging/deleting or modifying repo settings.
- `scripts/pr_review_thread_resolve.sh` and `scripts/pr_review_thread_unresolve.sh` require `--yes`; pass it only after explicit user approval.

## Auth and identity

```bash
gh auth status
gh auth login
gh auth logout
gh auth login --hostname github.example.com   # GHE
```

## Repo targeting and discovery

```bash
gh repo view --json nameWithOwner,url -q '"\(.nameWithOwner)\t\(.url)"'
gh repo set-default OWNER/REPO
gh repo list --limit 50
```

## Output formatting

```bash
# Return exactly the fields you need
gh issue list -R OWNER/REPO --limit 20 --json number,title,url -q '.[] | "\(.number)\t\(.title)\t\(.url)"'

# Discover supported JSON fields and jq patterns
gh <command> --help
gh help formatting
```

## Cheatsheet

```bash
# Repo
gh repo view OWNER/REPO --json nameWithOwner,defaultBranchRef,isPrivate,url
gh repo clone OWNER/REPO
gh repo fork OWNER/REPO

# Issues
gh issue list -R OWNER/REPO --state open --limit 50 --json number,title,author,labels,createdAt,url
gh issue view -R OWNER/REPO NUMBER --json number,title,body,author,labels,state,comments,url
gh issue create -R OWNER/REPO --title "..." --body "..."
gh issue edit -R OWNER/REPO NUMBER --add-label bug --remove-label "wontfix"
gh issue comment -R OWNER/REPO NUMBER --body "..."
gh issue close -R OWNER/REPO NUMBER --comment "..."
gh issue reopen -R OWNER/REPO NUMBER --comment "..."

# Labels / milestones
gh label list -R OWNER/REPO
gh label create -R OWNER/REPO "bug" --color FF0000 --description "..."
gh label edit -R OWNER/REPO "bug" --description "Defect"
gh label delete -R OWNER/REPO "obsolete-label"
gh milestone list -R OWNER/REPO
gh milestone create -R OWNER/REPO --title "v1.0" --description "..."
gh milestone edit -R OWNER/REPO 1 --title "v1.0.0"
gh milestone close -R OWNER/REPO 1

# Pull requests
gh pr list -R OWNER/REPO --state open --limit 50 --json number,title,author,headRefName,baseRefName,reviewDecision,statusCheckRollup,url
gh pr view -R OWNER/REPO NUMBER --json number,title,body,author,baseRefName,headRefName,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup,url
gh pr checkout NUMBER
gh pr create --fill
gh pr review -R OWNER/REPO NUMBER --approve
gh pr review -R OWNER/REPO NUMBER --comment --body "..."
gh pr merge -R OWNER/REPO NUMBER --merge   # or --squash / --rebase
gh pr status

# Discussions (gh discussion is in preview; commands work but may change)
gh discussion list -R OWNER/REPO --limit 30
gh discussion view -R OWNER/REPO NUMBER
gh discussion create -R OWNER/REPO --title "..." --body "..." --category "General"
gh discussion comment -R OWNER/REPO NUMBER --body "..."
gh discussion close -R OWNER/REPO NUMBER

# Actions
gh workflow list -R OWNER/REPO
gh workflow view -R OWNER/REPO WORKFLOW
gh workflow run -R OWNER/REPO WORKFLOW
gh run list -R OWNER/REPO --limit 20 --json databaseId,displayTitle,status,conclusion,createdAt,url
gh run watch -R OWNER/REPO RUN_ID
gh run view -R OWNER/REPO RUN_ID            # logs, jobs, and step details
gh run cancel -R OWNER/REPO RUN_ID
gh run rerun -R OWNER/REPO RUN_ID

# Releases
gh release list -R OWNER/REPO --limit 20 --json tagName,name,isDraft,isPrerelease,publishedAt
gh release view -R OWNER/REPO TAG --json name,tagName,body,isDraft,isPrerelease,publishedAt,url
gh release download -R OWNER/REPO TAG
gh release create -R OWNER/REPO v1.2.3 --title "v1.2.3" --notes "..."

# Gists
gh gist create --public --desc "..." path/to/file
gh gist list --limit 20
gh gist view GIST_ID

# Search
gh issue list -R OWNER/REPO --search "label:bug is:open sort:created-desc" --json number,title,url
gh pr list -R OWNER/REPO --search "review:required status:failure" --json number,title,url
gh search issues "repo:OWNER/REPO label:bug is:open" --limit 20
gh search prs "org:ORG is:open review:required" --limit 20
gh search repos "topic:cli language:go" --limit 20
```

## PR review feedback workflow

`gh` surfaces PR reviews and PR (issue) comments directly, but inline review comments and per-thread resolution state require `gh api`. Use the bundled scripts for this workflow.

### Read all feedback for a PR

```bash
scripts/pr_feedback.sh -R OWNER/REPO PR_NUMBER > pr-feedback.json
```

The script emits a single JSON object with `pr` (metadata + reviews + PR comments from `gh pr view`), `reviewComments` (inline comments via REST), and `reviewThreads` (GraphQL, including resolved/outdated state). It warns when any fetched set may be truncated.

Common projections:

```bash
# Review summaries
jq -r '.pr.reviews[]? | "\(.author.login)\t\(.state)\t\(.submittedAt // .createdAt // "")\t\(.url)"' pr-feedback.json

# PR (issue) comments
jq -r '.pr.comments[]? | "\(.author.login)\t\(.createdAt)\t\(.url)\n\(.body)\n"' pr-feedback.json

# Inline review comments (REST objects)
jq -r '.reviewComments[]? | "\(.user.login)\t\(.path):\(.line // 0)\t\(.html_url)\n\(.body)\n"' pr-feedback.json

# Unresolved review threads (GraphQL)
jq -r '.reviewThreads[] | select(.isResolved == false and .isOutdated == false) | "\(.id)\t\(.path):\(.line // 0)"' pr-feedback.json
```

### Reply back

Top-level PR comment:

```bash
gh pr comment -R OWNER/REPO PR_NUMBER --body "..."
```

General review comment:

```bash
gh pr review -R OWNER/REPO PR_NUMBER --comment --body "..."
```

Inline review comment (REST) — use when you have a numeric `comment_id`:

```bash
scripts/pr_review_comment_reply.sh -R OWNER/REPO PR_NUMBER COMMENT_ID --body "..."
```

Review thread (GraphQL) — preferred for thread-level replies and resolution:

```bash
thread_id="$(jq -r '.reviewThreads[] | select(.isResolved == false and .isOutdated == false) | .id' pr-feedback.json | head -n 1)"
scripts/pr_review_thread_reply.sh "$thread_id" --body "..."
scripts/pr_review_thread_resolve.sh --yes "$thread_id"
scripts/pr_review_thread_unresolve.sh --yes "$thread_id"   # reopen if needed
```

`--yes` is required for resolve/unresolve; pass it only after explicit user approval.

Creating a brand-new review thread (not a reply) has no bundled script — use the `addPullRequestReviewThread` GraphQL mutation via `gh api` (needs `path`, `body`, and a `line`/`side` or an attached review).

## `gh api` fallback (REST + GraphQL)

Use only when there is no dedicated `gh` command. Prefer read-only calls; confirm before write calls.

### REST basics

```bash
gh api -H "Accept: application/vnd.github+json" /repos/OWNER/REPO -q '{defaultBranch: .default_branch, private: .private}'
gh api --paginate /repos/OWNER/REPO/issues -q '.[] | {number: .number, title: .title, url: .html_url}'
```

### GraphQL basics

```bash
gh api graphql -f query='
  query($owner:String!, $name:String!) {
    repository(owner:$owner, name:$name) {
      nameWithOwner
      defaultBranchRef { name }
    }
  }' -F owner=OWNER -F name=REPO -q '.data.repository'
```
