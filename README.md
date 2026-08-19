# ❄️ hoenn

Declarative configuration for my personal machines. Hoenn uses a flake-parts
Nix flake to compose NixOS, nix-darwin, and system-manager configurations,
with shared modules for packages, desktop environments, networking, secrets,
and automatic upgrades.

For my personal homelab, see [johto](https://github.com/alyraffauf/johto). For
my production services, see [sinnoh](https://github.com/alyraffauf/sinnoh).

## Configurations

| Host                                                 | Platform       | Flake output                     |
| ---------------------------------------------------- | -------------- | -------------------------------- |
| [`fallarbor`](nix/hosts/nixos/fallarbor/README.md)   | NixOS          | `nixosConfigurations.fallarbor`  |
| [`mauville`](nix/hosts/nixos/mauville/README.md)     | NixOS          | `nixosConfigurations.mauville`   |
| [`pacifidlog`](nix/hosts/nixos/pacifidlog/README.md) | NixOS          | `nixosConfigurations.pacifidlog` |
| [`rustboro`](nix/hosts/nixos/rustboro/README.md)     | NixOS          | `nixosConfigurations.rustboro`   |
| [`sootopolis`](nix/hosts/nixos/sootopolis/README.md) | NixOS          | `nixosConfigurations.sootopolis` |
| [`fortree`](nix/hosts/darwin/fortree/README.md)      | nix-darwin     | `darwinConfigurations.fortree`   |
| `sootopolis`                                         | system-manager | `systemConfigs.sootopolis`       |

NixOS hardware discovery is captured with nixos-facter, disk layouts are
declared with Disko, and SOPS manages encrypted secrets. Shared WireGuard and
Tailscale modules connect hosts to the networks they need.

## Repository Layout

```text
nix/
├── hosts/  Per-host composition and hardware state
├── nixos/  Shared NixOS modules and features
├── darwin/  Shared nix-darwin modules
├── system-manager/  Shared system-manager modules
├── deployments.nix  blzrd deployment targets
├── devShells.nix  Development tools
└── treefmt.nix  Formatting and linting configuration
keys/  Public SSH keys used as age recipients
secrets/  SOPS-encrypted configuration
scripts/  Repository maintenance utilities
.github/workflows/  Flake checks and configuration builds
```

`flake.nix` recursively imports the modules under `nix/`. Each Nix file there
declares or extends a flake output, so new modules do not need to be added to a
central import list.

## Development

Enter the pinned toolchain with `nix develop`, or run `direnv allow` to load it
automatically. The shell includes Bun, Just, `nh`, SOPS, `ssh-to-age`, and
`blzrd`. Useful commands from the repository root include:

```bash
# Format Nix, YAML, Markdown, TypeScript, and shell files.
nix fmt

# Evaluate the flake and run its configured checks.
nix flake check

# Build configurations without activating them.
nix build .#nixosConfigurations.mauville.config.system.build.toplevel
nix build .#darwinConfigurations.fortree.config.system.build.toplevel
nix build .#systemConfigs.sootopolis

# Refresh the generated NixOS host hardware documentation.
bun scripts/generate-host-readmes.ts

# Discover repository maintenance recipes.
just
```

CI evaluates the complete flake and separately builds the development shell
plus NixOS, nix-darwin, and system-manager outputs.

## NixOS Deployments

`nix/deployments.nix` currently registers Mauville as the flake's `blzrd` node.
From the development shell, build and deploy that node with:

```bash
blzrd switch mauville # Activate Mauville and set its boot default
blzrd boot mauville   # Set Mauville's boot default without activating it
```

Run `nix flake check` and build the affected configuration first. Supplying no
node name targets every registered node, so name the intended node explicitly
to keep the command safe as the deployment set grows.

## Secrets

Secrets are encrypted with SOPS for the recipients declared in `.sops.yaml`.
Never commit decrypted values or private keys.

```bash
just sops-bootstrap           # Install this machine's age key once
just sops-edit tailscale.yaml # Edit an encrypted secret
just sops-rekey               # Update recipients after keys/ changes
```

Commit `.sops.yaml` and all re-encrypted files together after changing a public
key in `keys/`.

See [AGENTS.md](AGENTS.md) for contribution and validation guidelines. This
project is available under the [MIT License](LICENSE.md).
