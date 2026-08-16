# ❄️ hoenn

Personal Nix configuration for NixOS, nix-darwin, and system-manager.

The flake is organized as small, composable modules. Shared behavior lives
under `modules/nixos`, `modules/darwin`, and `modules/system-manager`; each
host composes the pieces it needs under `modules/hosts`.

## Configurations

| Platform       | Host       | Flake output                     |
| -------------- | ---------- | -------------------------------- |
| NixOS          | Fallarbor  | `nixosConfigurations.fallarbor`  |
| NixOS          | Mauville   | `nixosConfigurations.mauville`   |
| NixOS          | Rustboro   | `nixosConfigurations.rustboro`   |
| NixOS          | Sootopolis | `nixosConfigurations.sootopolis` |
| nix-darwin     | Fortree    | `darwinConfigurations.fortree`   |
| system-manager | Sootopolis | `systemConfigs.sootopolis`       |

Hardware discovery is captured with nixos-facter, disk layouts are declared
with Disko, and SOPS manages encrypted secrets.

## Repository layout

```text
modules/
├── nixos/           Shared NixOS modules, features, services, and users
├── darwin/          Shared nix-darwin modules
├── system-manager/  Shared system-manager modules
└── hosts/           Per-host composition and hardware state
```

`flake.nix` imports the `modules/` tree. Keep each Nix file there as a
flake-parts module that declares or extends a flake output; keep standalone
helpers outside that tree.

## Common commands

Run these commands from the repository root.

```bash
# Format and evaluate the complete flake.
nix fmt
nix flake check

# Build an output before applying it.
nix build .#nixosConfigurations.mauville.config.system.build.toplevel
nix build .#darwinConfigurations.fortree.config.system.build.toplevel
nix build .#systemConfigs.sootopolis

# Apply a configuration on its target host.
sudo nixos-rebuild switch --flake .#mauville
darwin-rebuild switch --flake .#fortree
```

The Sootopolis system-manager configuration is built as shown above and is
also refreshed by its configured system-manager auto-upgrade service.

## Secrets

Secrets in `secrets/` are SOPS-encrypted for every public key in `keys/`.
NixOS and nix-darwin decrypt host secrets with
`/etc/ssh/ssh_host_ed25519_key` during activation. Edit a secret with SOPS,
then build and apply the affected configuration:

```bash
sops secrets/tailscale.yaml
```

When adding or removing a recipient, update `.sops.yaml` and re-encrypt every
secret before committing the change.
