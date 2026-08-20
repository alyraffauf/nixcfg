# Repository Guidelines

## Project Structure & Module Organization

`flake.nix` recursively imports the flake-parts modules under `nix/`. Shared
platform settings live in `nix/nixos/`, `nix/darwin/`, and
`nix/system-manager/`; Home Manager configurations live in
`nix/homes/home-manager/<user>/`; host composition and hardware state live in
`nix/hosts/<platform>/<host>/`. Shared flake concerns such as deployments,
overlays, development shells, and formatting live directly in `nix/`.
Utilities belong in `scripts/`, public SSH keys in `keys/`, SOPS-encrypted
configuration in `secrets/`, and GitHub Actions workflows in
`.github/workflows/`.

## Build, Test, and Development Commands

- `nix develop` enters the pinned development shell with Bun, Just, `nh`, SOPS,
  `ssh-to-age`, `blzrd`, and repository tooling. Direnv users can run
  `direnv allow` to load the same shell automatically.
- `nix fmt` runs treefmt across Nix, YAML/JSON/Markdown, TypeScript, and shell
  files.
- `nix flake check` evaluates the complete flake and runs its configured checks;
  this is the primary validation command.
- `nix build .#nixosConfigurations.mauville.config.system.build.toplevel`
  builds one NixOS host without activating it. Replace `mauville` with the
  affected hostname.
- `nix build .#darwinConfigurations.fortree.config.system.build.toplevel`
  validates the nix-darwin configuration.
- `nix build .#systemConfigs.sootopolis` validates the system-manager output.
- `bun scripts/generate-host-readmes.ts` refreshes generated hardware sections
  from each NixOS host's `facter.json`. Do not hand-edit content between the
  generated-section markers.
- `just` lists maintenance recipes, including SOPS editing and recipient
  management commands.

Run formatting and `nix flake check` before submitting changes. Also build every
affected configuration output.

## Deployments

`nix/deployments.nix` currently registers `mauville` as a `blzrd` node. After
validation, use `blzrd switch mauville` to activate its new configuration and
set the boot default, or `blzrd boot mauville` to set the boot default without
activating it. A bare `blzrd switch` targets every registered node, so prefer an
explicit node name. Do not deploy merely to validate a change.

## Coding Style & Naming Conventions

Let `nix fmt` define formatting through Alejandra, deadnix, statix, Prettier,
shfmt, and ShellCheck. Use two-space indentation in Nix and YAML. Keep modules
small and composable, preferably with one concern per file. Use lowercase,
hyphenated filenames such as `auto-upgrade.nix`, and keep established Pokémon
hostnames consistent across paths and flake attributes.

## Testing Guidelines

There is no separate unit-test suite or coverage threshold. Treat successful
flake evaluation and affected-output builds as required validation. Changes to
shared NixOS modules should build for every consuming NixOS host; changes to
Darwin or system-manager modules should build Fortree or the Sootopolis
system-manager output, respectively. Changes to Home Manager modules should
build Sootopolis's NixOS output. Never switch or deploy a configuration merely
to test it.

## Commit & Pull Request Guidelines

History favors concise Conventional Commit-style subjects such as
`feat(nixos): ...`, `fix(wireguard): ...`, and `docs: ...`. Keep each commit
focused. Pull requests should explain operational impact, identify affected
hosts or modules, link related issues when applicable, and list the exact checks
and builds run. Call out activation, reboot, migration, and rollback concerns
explicitly. Include screenshots only for user-visible desktop changes.

## Security & Configuration

Never commit decrypted secrets or private keys. Edit encrypted files with
`just sops-edit <file>.yaml`. After changing recipients in `keys/`, run
`just sops-rekey`, review `.sops.yaml` and every re-encrypted file, and commit
those updates together.
