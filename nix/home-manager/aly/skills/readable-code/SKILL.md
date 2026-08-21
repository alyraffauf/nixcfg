---
name: readable-code
description: Readable, maintainable code standards. Use when writing source code.
---

# Readable & Scalable Code Standards

> **Readability first.** Code is read far more often than it is written. Write for the human who opens this file six months from now, or six minutes from now, with no context.

## Naming

> **Names are the primary interface for understanding code.**

- **Reveal intent.** A name should answer _why_ it exists and _how_ it is used.
- **Avoid abbreviations.** `customerAddress` not `custAddr`.
- **Avoid single-letter names** unless they are the **universal idiomatic convention** for that language (e.g., `i`/`j` for loop indices in C-style languages, `e` for error in Go, `T` for type parameters in generics). When in doubt, spell it out.
- **No leetcode-style shortcuts.** `currentNode` not `curr`; `previousValue` not `prev`; `result` not `res`; `answer` not `ans`.
- **Pronounceable names.** `generationTimestamp` not `gen_ts`.

**By type:** variables = noun phrase (`activeUserCount`, `processedLines`); functions = verb+noun (`findUserByEmail`, `calculateTotalPrice`); booleans = question form (`isActive`, `hasPermission`, `canEdit`, `shouldRetry`); constants = SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS`); collections = plural noun (`users`, `pendingOrders`); predicates/filters = past participle or adjective (`enabledFeatures`, `matchedRecords`).

> **Rule:** If you need a comment to explain a name, rename it.

---

## Functions

**Functions** — under 40 lines (don't artificially split one clear responsibility just to hit the count); one responsibility and one abstraction level per function; 0–2 args ideal (3 acceptable, 4+ → struct/object with named fields); no hidden side effects (`checkUserStatus` must not also update the database); guard clauses / return early; no clever one-liners (prefer explicit multi-step logic over dense expressions); extract a meaningful chunk when you can, but inline a one-liner used only once.

---

## Code Structure

**Code structure** — guard clauses (return early for nulls/errors/edge cases); flat over nested (max 2 levels visual nesting); step-down rule (high-level functions first, helpers below); colocation (keep related code close, don't scatter one concept across files); whitespace as paragraph punctuation within a function; named constants not magic numbers (`MAX_RETRIES` not `3`).

---

## Scale & Flexibility

> **Solve today's problem with tomorrow's load in mind.**

**Scale** — YAGNI (no abstractions for hypothetical requirements); scalable boundaries (interfaces, data models, and failure modes that grow without rewrites); config over hardcode (timeouts, limits, feature flags, URLs, thresholds); loose coupling (a change in one module shouldn't cascade); fail loudly, recover cleanly (silent failures become catastrophic at scale); keep observability easy to add (logs, metrics, tracing); wrap third-party deps so they can be replaced or mocked.

---

## Comments & Didacticism

> **The code is the explanation. Comments are the apology.**

- **Do not state the obvious.**

  ```
  ❌  // increment counter by 1
      counter += 1;

  ✅  counter += 1;
  ```

- **Do not write tutorials in comments.** Assume the reader knows the language. Explain _why_ a non-obvious choice was made, not _what_ the syntax does.
- **Do not leave commented-out code.** Delete it. Git remembers.

- **Use simple, direct clauses in comments.** Prefer imperative style. Write `Retry on timeout` not `This will retry the operation if a timeout occurs`. Comments should be brief and to the point.
- **Do document surprises.** If the code must diverge from an obvious approach for a subtle reason, a brief comment is warranted.

---

## Before Editing Any File

**Stop and think.**

| Question                    | Why it matters                                        |
| --------------------------- | ----------------------------------------------------- |
| What imports this file?     | Signatures changes may break callers.                 |
| What does this file import? | Changing an interface may require downstream updates. |
| What tests cover this?      | Tests will fail if behavior changes.                  |
| Is this shared code?        | A change here affects many places.                    |

> **Rule:** Edit the file AND all dependent files in the same task. Never leave broken imports, missing updates, or orphaned references.

---

## AI Coding Style

| Situation                              | Action                                                                                                                               |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| User asks for a feature                | Write it directly and clearly. Consider how it fits the existing architecture.                                                       |
| User reports a bug                     | Fix it. Do not explain the fix unless asked. Check if the root cause affects other areas.                                            |
| No clear requirement                   | Ask, do not assume.                                                                                                                  |
| Multiple valid approaches              | Choose the most readable and the one that respects existing boundaries, not the most impressive.                                     |
| User asks about architecture or design | Explain tradeoffs concisely. Recommend the approach that minimizes future maintenance burden and cognitive load, not the most novel. |
| Encountering messy existing code       | Follow the Boy Scout rule: leave it cleaner. But do not refactor unrelated code without permission.                                  |
| Performance vs. readability tension    | Default to readability. Optimize only when there is measurable evidence of a bottleneck, not on speculation.                         |

---

## Self-Check Before Completing

Before reporting a task complete, verify:

- [ ] **Goal met?** Did I do exactly what the user asked?
- [ ] **All files edited?** Did I modify every necessary file, including dependents?
- [ ] **Code works?** Did I verify the change compiles / runs / passes tests?
- [ ] **Readable?** Would a new teammate understand this without explanation?
- [ ] **No obvious comments?** Is the code self-documenting via names and structure?
- [ ] **No abbreviations or single-letter vars?** (idiomatic `i`/`j`/`e`/`T` are fine; no `curr`, `prev`, `res`, `tmp`).
- [ ] **No magic numbers?** Named constants over bare literals (`MAX_RETRIES` not `3`).
- [ ] **No deep nesting?** Prefer guard clauses and early returns over nested `if`.
- [ ] **No god functions?** Each function does one thing, named precisely.
- [ ] **No clever one-liners?** Explicit multi-step logic over dense expressions.
- [ ] **No extracted trivialities?** Don't extract a one-liner used only once.
- [ ] **Scale respected?** Did I avoid tunnel vision? Does this change hold up if usage grows 10x?
- [ ] **Nothing forgotten?** Edge cases, error paths, cleanup handled?

> **Rule:** If any check fails, fix it before completing.
