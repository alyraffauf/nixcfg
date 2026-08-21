---
name: gh-cli
description: Standardize all GitHub work via `gh` CLI (repos, issues, PRs, reviews, Actions, labels, releases). Trigger on any GitHub URL (incl. deep links like /pull/123, /issues/123, #issuecomment-…).
---

# GitHub `gh` CLI

## Overview

Use `gh` for GitHub operations with explicit repo targeting, JSON output, and command help-driven discovery of flags/fields. Avoid scraping human-readable output and avoid raw REST calls unless you must (use `gh api` as the controlled fallback).

## Quick start

1. Verify `gh` is installed and authenticated (once per session, or when debugging auth/repo targeting):
   ```bash
   gh --version
   gh auth status
   ```
2. Set explicit repo context:
   ```bash
   # One-off target
   gh <noun> <verb> -R OWNER/REPO ...
   # Repeated work in a checkout
   gh repo set-default OWNER/REPO
   ```
3. Discover flags/fields on demand:
   ```bash
   gh <command> --help
   gh help formatting
   ```

## Operating rules (do not skip)

1. Prefer first-class commands over APIs.
   - Use `gh issue`, `gh pr`, `gh repo`, `gh run`, `gh workflow`, `gh release`, etc.
   - Use `gh api` only when the CLI lacks a dedicated command (document the endpoint and why).

2. Avoid guessing flags/fields; discover them.
   - Use `gh <command> --help` to find flags and supported `--json` fields.
   - Use `gh help formatting` for `--json`, `--jq`, and `--template` patterns.

3. Prefer machine-readable output.
   - Use `--json <fields> -q '<jq>'` instead of parsing table output.
   - When you need just one value, return only that value (not the full blob).

4. Make repo targeting explicit.
   - Prefer `-R OWNER/REPO` when not operating in a known local checkout.
   - If you infer repo from the current directory, confirm it via `gh repo view --json nameWithOwner -q .nameWithOwner`.

5. Treat state changes as production-impacting.
   - Ask for confirmation before destructive or hard-to-reverse changes: closing/merging/deleting, resolving or unresolving review threads, and modifying branch protections or permissions.
   - Routine, easily-reversed workflow output — posting a review reply, commenting, or checking out a PR branch (`gh pr checkout`) — does not require an extra gate.
   - When modifying settings, make changes small and reversible.

## Common tasks

See `references/gh-commands.md` for a concise command cookbook covering repos, issues, PRs, Actions, releases, search patterns, and `gh api` fallbacks. Prefer `gh <command> --help` for exhaustive flag/field lists.

## Tooling

Run a quick environment/context capture when debugging auth/repo targeting problems:

```bash
scripts/gh_context.sh
```

This prints `gh` version/auth status and tries to identify the active repo (when run inside a checkout).

Fetch a PR’s full review feedback bundle as JSON:

```bash
scripts/pr_feedback.sh -R OWNER/REPO PR_NUMBER > pr-feedback.json
```

Reply to review feedback:

```bash
# Inline review comment (REST)
scripts/pr_review_comment_reply.sh -R OWNER/REPO PR_NUMBER COMMENT_ID --body "..."

# Review thread (GraphQL)
scripts/pr_review_thread_reply.sh PRRT_... --body "..."

# Resolve a review thread (state change; --yes required)
scripts/pr_review_thread_resolve.sh --yes PRRT_...

# Reopen a resolved thread (state change; --yes required)
scripts/pr_review_thread_unresolve.sh --yes PRRT_...
```
