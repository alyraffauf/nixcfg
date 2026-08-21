---
name: nix
description: Use Nix for installing packages, adding tools, setting up dev environments, and resolving missing binaries. Prefer Nix over apt, dnf, or brew when nix is available. Nix provides the runtime; use language PMs (npm, pip, cargo) inside a nix shell for project deps.
---

# Nix

> **Nix provides the runtime and toolchain. Language PMs (npm, pip, cargo) manage project-level deps inside that shell.**

## Detection

```bash
scripts/nix-detect
# Output keys: nix_available, flakes_enabled, is_nixos, is_flake_project, flake_path
# → {"nix_available":true,"flakes_enabled":true,"is_nixos":false,"is_flake_project":false,"flake_path":""}
```

Manual: `command -v nix`, `nix flake --help >/dev/null 2>&1`, `test -f /etc/NIXOS`, `nix flake metadata 2>/dev/null`.
If flakes are off, pass `--extra-experimental-features 'nix-command flakes'`.

## How to Run a Package

**Default:** `scripts/nix-ensure <tool> [args]` — checks PATH first, fetches via Nix if missing. Use this for any standalone tool.

When `nix-ensure` doesn't apply (flake dev shells, chaining language PMs):

| Scenario           | Command                                                          |
| ------------------ | ---------------------------------------------------------------- |
| Flake dev → build  | `nix develop -c just build`                                      |
| Flake dev → test   | `nix develop -c npm test`                                        |
| No flake, need npm | `nix shell nixpkgs#nodejs -c 'npm ci && npm test'`               |
| No flake, need pip | `nix shell nixpkgs#python3 -c 'pip install -r requirements.txt'` |

### The `-c` Rule

Every agent `nix shell` or `nix develop` call MUST include `-c <command>`, or it hangs waiting for input.

| ❌ Wrong                                | ✅ Right                              |
| --------------------------------------- | ------------------------------------- |
| `nix shell nixpkgs#jq` then `jq . file` | `nix shell nixpkgs#jq -c 'jq . file'` |
| `nix develop` then `npm test`           | `nix develop -c npm test`             |

### Banned → Replacement

| ❌                         | ✅                                      |
| -------------------------- | --------------------------------------- |
| `nix-shell -p pkg`         | `nix shell nixpkgs#pkg`                 |
| `nix-env -i pkg`           | `nix profile install nixpkgs#pkg`       |
| `nix-build`                | `nix build`                             |
| `sudo apt-get install pkg` | `nix shell nixpkgs#pkg`                 |
| `brew install pkg`         | `nix shell nixpkgs#pkg`                 |
| `pip install pkg` (global) | `nix shell nixpkgs#python3Packages.pkg` |
| `npm install -g pkg`       | `nix shell nixpkgs#nodePackages.pkg`    |
| `cargo install pkg`        | `nix shell nixpkgs#pkg`                 |
| `curl ... \| sh`           | `nix shell nixpkgs#pkg`                 |

## Common Packages

| Tool    | Nix Ref             | Notes               |
| ------- | ------------------- | ------------------- |
| jq      | `nixpkgs#jq`        |                     |
| ripgrep | `nixpkgs#ripgrep`   |                     |
| fd      | `nixpkgs#fd`        |                     |
| fzf     | `nixpkgs#fzf`       |                     |
| bat     | `nixpkgs#bat`       |                     |
| delta   | `nixpkgs#git-delta` | name is `git-delta` |
| gh      | `nixpkgs#gh`        |                     |
| direnv  | `nixpkgs#direnv`    |                     |
| just    | `nixpkgs#just`      |                     |
| yq      | `nixpkgs#yq-go`     | name is `yq-go`     |
| watch   | `nixpkgs#procps`    | in procps           |

| Lang   | Runtime                           | Tools                                                          |
| ------ | --------------------------------- | -------------------------------------------------------------- |
| Python | `nixpkgs#python3`                 | `nixpkgs#ruff`, `nixpkgs#black`, `nixpkgs#pyright`             |
| Node   | `nixpkgs#nodejs`                  | `nixpkgs#nodePackages.prettier`, `nixpkgs#nodePackages.eslint` |
| Rust   | `nixpkgs#cargo` + `nixpkgs#rustc` | `nixpkgs#rust-analyzer`, `nixpkgs#clippy`                      |
| Go     | `nixpkgs#go`                      | `nixpkgs#gopls`, `nixpkgs#golangci-lint`                       |
| C/C++  | `nixpkgs#gcc` / `nixpkgs#clang`   | `nixpkgs#clang-tools`                                          |
| Nix    | —                                 | `nixpkgs#nil`                                                  |

**Tricky names:** delta→`git-delta`, yq→`yq-go`, watch→`procps`, awscli→`awscli2`.

## Missing from nixpkgs?

1. Try broader search: `nix search nixpkgs name`
2. Try vendor flake: `nix run github:vendor/project`
3. Try unstable: `nix shell github:NixOS/nixpkgs/nixos-unstable#pkg`
4. Last resort: language PM inside `nix shell nixpkgs#python3`

Never `curl | sh`.

## Helpers

All in `scripts/` relative to this skill.

```bash
scripts/nix-detect          # JSON env classification
scripts/nix-ensure jq . f   # run jq, fetch via nix if missing
scripts/nix-ensure -p git-delta delta f   # pkg name ≠ binary name
scripts/nix-verify          # smoke test nix setup
```

## Flake & Project

```bash
# Interactive (no -c — for users, not agents)
nix develop
nix shell nixpkgs#pkg1 nixpkgs#pkg2

# Flake lifecycle
nix flake init -t nixpkgs#python
nix flake update && nix flake check
nix build && nix run .#app

# direnv (auto-activate on cd)
echo "use flake" > .envrc && direnv allow
echo "use nix" > .envrc && direnv allow

# Permanent (rare)
nix profile install nixpkgs#pkg
```
