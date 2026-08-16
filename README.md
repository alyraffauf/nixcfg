# ❄️ hoenn

Personal Nix configuration for NixOS, nix-darwin, and system-manager.

The flake is organized as small, composable modules, both inspired and
uninspired by the dendritic pattern and other trends.. Shared behavior
lives under `modules/nixos`, `modules/darwin`, and `modules/system-manager`;
each host composes the pieces it needs under `modules/hosts`.

It currently defines NixOS configurations for Fallarbor, Rustboro, and
Sootopolis; a nix-darwin configuration for Fortree; and a system-manager
configuration for Sootopolis (which doesn't always run NixOS!). Hardware
discovery is captured with nixos-facter, disk layouts are declared with
Disko, and SOPS manages encrypted secrets.
