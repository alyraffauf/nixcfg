# nixcfg

My comprehensive NixOS flake for managing my laptop, desktop, and home lab environments.

NOTE: Some hosts and configuration options have migrated to [alyraffauf/bazznix](https://github.com/alyraffauf/bazznix), my project to create a [bazzite-like](https://bazzite.gg) experience on NixOS.

![](./_img/rosepinemoon.png)
![](./_img/rosepinedawn.png)

## Features

- **Hyprland:** Dynamic tiling Wayland compositor and window manager.
- **Stylix:** Auto-gnerated base16 themes for the whole desktop.
- **Encryption:** Encrypted boot drives with Secure Boot and LUKS with TPM decryption.
- **Home Lab:** Media, file sharing, and more, split between two PCs with efficient routing via reverse proxy.

## Inputs

This flake takes a variety of upstream and third party flakes as inputs:

- [agenix](https://github.com/ryantm/agenix): secrets storage and orchestration.
- [disko](https://github.com/nix-community/disko): declarative partitions and disk configuration.
- [home-manager](https://github.com/nix-community/home-manager): declarative dotfile and user package management.
- [hyprland](https://github.com/hyprwm/Hyprland): great dynamic tiling wayland compositor.
- [iio-hyprland](https://github.com/JeanSchoeller/iio-hyprland): autorotate daemon for Hyprland.
- [lanzaboote](https://github.com/nix-community/lanzaboote): secure boot for NixOS.
- [nur](https://github.com/nix-community/NUR): extra packages from the nix user repository.
- [stylix](https://github.com/danth/stylix): system-wide color schemes and typography.

## Outputs

- homeManagerModules.aly: my home-manager config.
- homeManagerModules.default: app modules + everything you need for a competent Hyprland desktop (and a few others).
- homeManagerModules.dustin: my husband's home-manager config.
- nixosModules.common: various common modules specific to my hosts.
- nixosModules.nixos: opinionated desktop, app, and service options.
- nixosModules.users: basic user configuration options.
- overlays.default: adds every package output to nixpkgs.
- overlays.tablet: tablet optimizations, mainly for electron apps.

In addition, this flake outputs NixOS configurations, home-manager configurations, and various hardware modules for all of my hosts and users.

## Deploying to NixOS

Each hardware configuration is host-specific. If you fork this repository, add a host configuration for your own hardware. Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) and will not be available without the private decryption keys.

### Enabling Flakes

While widely used and considered stable, [flakes](https://wiki.nixos.org/wiki/Flakes) are still considered experimental. To enable Flakes, add the following lines to your `configuration.nix` and rebuild.

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Alternatively, pass `--experimental-features "nix-command flakes"` to `nix` to temporarily use flakes.

### Building Flake

In order to deploy this Flake on your host, run the following command:

```console
sudo nixos-rebuild boot --flake github:alyraffauf/nixcfg#$HOSTNAME
```

Substitute `$HOSTNAME` for whichever hostname you have chosen. Reboot to apply the flake's configuration for the chosen host.

### Installing from Live USB

If you want to install NixOS from this flake, run the following commands, ideally from a NixOS live environment, providing the hostname associated with a NixOS configuration specified in `flake.nix` when prompted.

```console
sudo nix --experimental-features "nix-command flakes" run github:alyraffauf/nixcfg
```
