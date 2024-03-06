# nixcfg
![](./_img/nixos-gnome.png)
![](./_img/nixos-kde.png)

## Hosts

### Petalburg
Lenovo Yoga 9i Gen 8 convertible running nixos-unstable. Core i7 1360P, 16GB RAM, 512GB SSD. Runs GNOME, home directory managed by [home-manager](https://github.com/nix-community/home-manager).

### Rustboro
Thinkpad T440p running nixos-unstable. Uses KDE Plasma 6. Home directory managed by home-manager.

### Mauville
Gaming desktop & home lab running [Slateblue](https://github.com/alyraffauf/slateblue), a customized [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) image made with [BlueBuild](https://github.com/blue-build/template). Home directory managed by home-manager. Ryzen 5 2600, 16GB RAM, Radeon RX 6700.

## Deploying to NixOS
> :red_circle: **READ**: **Do not deploy this flake directly to your machine. It won't work.**
> This is my own [NixOS](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) flake for my personal devices.
> Each hardware-configuration is host-specific. If you fork this repository, replace them with the hardware-configuration.nix that NixOS generates for you.

### Enabling Flakes
While widely used and considered stable, [flakes](https://nixos.wiki/wiki/Flakes) are still considered eperimental. To enable Flakes, add the following lines to your `configuration.nix` and rebuild.
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
### Building Flake
In order to deploy this Flake on your host, run the following command:
```
sudo nixos-rebuild boot --flake github:alyraffauf/nixcfg
```
Reboot to apply the flake's configuration for the chosen host.
