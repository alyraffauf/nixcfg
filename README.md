# nixcfg
NixOS flake for all mine + my husband's hosts, including modules for Hyprland, Sway, GNOME, and a variety of [home lab](https://github.com/alyraffauf/raffauflabs) services running on a mix of nix-native and OCI containers. Built with [agenix](https://github.com/ryantm/agenix) for managing secrets, [disko](https://github.com/nix-community/disko) for automatically partioning drives, and [home-manager](https://github.com/nix-community/home-manager) for managing dotfiles and home configuration.

## Rice
![](./_img/hyprland.png)

## Deploying to NixOS
> :red_circle: **Do not deploy this flake unmodified to your machine. It won't work.**
> This is my own [NixOS](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) flake for my personal devices.
> Each hardware configuration is host-specific. If you fork this repository, add a host configuration for your own hardware.
> Secrets are encrypted with [agenix](https://github.com/ryantm/agenix) and will not be available without the private decryption keys.

### Enabling Flakes
While widely used and considered stable, [flakes](https://nixos.wiki/wiki/Flakes) are still considered experimental. To enable Flakes, add the following lines to your `configuration.nix` and rebuild.
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
> :red_circle: **This will erase your computer's disk** as specified by the host configuration, installing a fresh copy of NixOS. Backup first!

If you want to install NixOS from this flake, run the following commands, ideally from a NixOS live environment, substituting `$HOSTNAME` with a NixOS configuration specified in `flake.nix`.
```console
sudo nix --experimental-features "nix-command flakes" run github:alyraffauf/nixcfg -- $HOSTNAME
```