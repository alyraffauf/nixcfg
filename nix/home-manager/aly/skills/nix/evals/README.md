# nix skill — evaluations

Rubric-scored agent-behavior scenarios in the format described by the
[Agent Skills best-practices guide](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices).
There is no built-in runner; score each scenario by observing an agent (with
the `nix` skill loaded) against the `expected_behavior` list, and compare
against `baseline_without_skill` to confirm the skill is earning its keep.

| Scenario                       | What it tests                                           |
| ------------------------------ | ------------------------------------------------------- |
| `01-use-nix-not-apt.json`      | Intercepts `apt`/`dnf`/`brew` and routes to nix         |
| `02-c-flag-no-hang.json`       | The `-c` rule (agents don't hang on interactive shells) |
| `03-tricky-package-names.json` | `git-delta`/`yq-go`/`procps` name mismatches            |
| `04-nix-detect-contract.json`  | `nix-detect` output keys + graceful no-nix path         |

Deterministic script unit-tests (e.g. `nix-detect` on a fixtures flake) are a
worthwhile future addition for catching regressions like an output-shape change.
