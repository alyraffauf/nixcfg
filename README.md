# nixcfg

## Deploying to NixOS
> :red_circle: **READ**: **Do not deploy this flake directly to your machine. It won't work.**
> This is my own NixOS and home-manager flake for my personal devices.
> This includes laptops running nixos-unstable and a home lab/gaming desktop running [Slateblue](https://github.com/alyraffauf/slateblue),
> a customized [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/) image made with [BlueBuild](https://github.com/blue-build/template).
> Each hardware-configuration is host-specific. If you fork this repository, replace them with the hardware-configuration.nix that NixOS generates for you.

### Enabling Flakes
Add the following lines to your `configuration.nix` and rebuild.
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
### Building Flake
Run the following command.
```bash
sudo nixos-rebuild boot --flake github:alyraffauf/nixcfg
```
Reboot and the flake's configuration will be applied.
