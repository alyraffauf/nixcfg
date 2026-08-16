# Repository Guidelines

## Project Structure & Module Organization

This repository manages NixOS, nix-darwin, and system-manager hosts through a flake-parts configuration. `flake.nix` defines inputs and imports the module tree. Put reusable platform configuration in `modules/nixos/`, `modules/darwin/`, or `modules/system-manager/`; compose machine-specific settings under `modules/hosts/<platform>/<hostname>/`. Shared flake modules, such as deployments, overlays, development shells, and formatting, live directly in `modules/`. Public age/SSH recipients belong in `keys/`; encrypted SOPS documents belong in `secrets/`. GitHub Actions workflows are in `.github/workflows/`.

## Build, Test, and Development Commands

Run commands from the repository root:

- `nix fmt` formats Nix, shell, Markdown/YAML, and related files through treefmt.
- `nix flake check` evaluates the complete flake and runs configured checks; use this before every pull request.
- `nix build .#nixosConfigurations.mauville.config.system.build.toplevel` builds one NixOS host without applying it. Substitute the affected hostname.
- `nix build .#darwinConfigurations.fortree.config.system.build.toplevel` validates the Darwin configuration.
- `nix build .#systemConfigs.sootopolis` validates the system-manager output.
- `just` lists maintenance recipes; for example, `just update-nixpkgs` updates pinned nixpkgs inputs.

## Coding Style & Naming Conventions

Use two-space indentation and let Alejandra determine Nix layout. Keep modules small and composable; prefer one concern per file. Follow existing lowercase, hyphenated filenames such as `auto-upgrade.nix`, and use established Pokémon hostnames consistently in paths and flake attributes. Treefmt also runs deadnix, statix, Prettier, ShellCheck, and shfmt; resolve their findings rather than bypassing them.

## Testing Guidelines

There is no separate unit-test suite or coverage threshold. Treat `nix flake check` as the baseline test, then build every affected host output. Changes to shared modules should be validated against all consuming platforms or hosts. Do not switch or deploy a configuration merely to test it.

## Secrets & Configuration Safety

Never commit decrypted secret values or private keys. Edit encrypted files with `sops secrets/<name>.yaml` or `just sops-edit <name>.yaml`. After changing recipients in `keys/`, run `just sops-rekey` and commit the updated `.sops.yaml` and encrypted files together.

## Commit & Pull Request Guidelines

Recent history favors concise, imperative subjects with an area or Conventional Commit prefix, for example `feat: add Mauville NixOS host`, `fix(nixos): ...`, or `docs: ...`. Keep each commit focused. Pull requests should identify affected hosts/modules, explain operational impact, link relevant issues, and list the exact checks and builds run. Include screenshots only for user-visible desktop changes.
