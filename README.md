# nixos

My comprehensive NixOS flake for managing my laptop, desktop, and home lab environments.

![](./_img/hyprland.png)

## Features

- **Hyprland:** Dynamic tiling Wayland compositor and window manager.
- **Home Lab Services:** Media, file sharing, and more.
- **Reverse Proxy:** Efficient traffic routing for my home lab services.
- **Modular Configuration:** Reasonably adaptable for different hardware and use cases.

## Inputs

This flake takes a variety of inputs, first and foremost my other flakes:

- [nixhw](https://github.com/alyraffauf/nixhw): opinionated set of generic (AMD, Intel, Laptop, SSD) and specific (Framework 13, Yoga 9i, Thinkpad T440p) hardware configuration modules for NixOS.
- [raffauflabs](https://github.com/alyraffauf/raffauflabs): everything (containers, services, nginx, etc) that makes my [home lab](https://raffauflabs.com) a home lab.

As well as upstream third-party projects that I use for various tasks:

- [agenix](https://github.com/ryantm/agenix): secrets storage and orchestration.
- [disko](https://github.com/nix-community/disko): declarative partitions and disk configuration.
- [home-manager](https://github.com/nix-community/home-manager): declarative dotfile and user package management.
- [hyprland](https://github.com/hyprwm/Hyprland): great dynamic tiling wayland compositor.
- [iio-hyprland](https://github.com/JeanSchoeller/iio-hyprland): autorotate daemon for Hyprland.
- [nixvim](https://github.com/nix-community/nixvim): helpful neovim modules.
- [nur](https://github.com/nix-community/NUR): extra packages from the nix user repository.

## Outputs

- homeManagerModules.default: app modules + everything you need for a competent Hyprland desktop (and a few others).
- nixosModules.base: opinionated basic system configuration.
- nixosModules.nixos: opinionated desktop, app, and service modules.
- nixosModules.users: basic user configuration..

In addition, this flake outputs NixOS configuration and home-manager configurations for all of my hosts and users, respectively.

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
