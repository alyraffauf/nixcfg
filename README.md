# nixcfg
![](./_img/nixos-hyprland.png)
![](./_img/nixos-gnome.png)
![](./_img/nixos-kde.png)

## Hosts
| Host    |            lavaridge |               petalburg |               rustboro |                mauville |
|---------|---------------------:|------------------------:|-----------------------:|------------------------:|
| Model   |  Framework Laptop 13 |    Lenovo Yoga 9i Gen 8 |         ThinkPad T440p | Custom Mini-ITX Desktop |
| Display | 13.5" 2256x1504 60Hz | 14" 2880x1800 90hz OLED |     14" 1920x1080 60hz |  34" 3440x1440 160Hz VA |
| CPU     |      AMD Ryzen 7640U |     Intel Core i7-1360P |    Intel Core i5-4210M |        AMD Ryzen 5 2600 |
| RAM     |    32GB DDR5-5600Mhz |     16GB LPDDR5-5200Mhz |     16GB DDR3L-1600Mhz |       16GB DDR4-3200Mhz |
| GPU     |      AMD Radeon 760M |  Intel Iris Xe Graphics | Intel HD Graphics 4600 |      AMD Radeon Rx 6700 |
| Storage |     1TB Sk hynix P41 |      512GB M.2 PCIe 4.0 |         512GB SATA SSD |        1TB M.2 PCIe 3.0 |
| OS      |       NixOS Unstable |          NixOS Unstable |         NixOS Unstable |          NixOS Unstable |
<!-- | Desktop |                GNOME |                   GNOME |             KDE Plasma |                   GNOME | -->

## Home Lab Services
| Service          |                       Source/Runtime |                           Domain |
|------------------|-------------------------------------:|---------------------------------:|
| Nix Binary Cache |                  nix-serve (nixpkgs) | https://nixchace.raffauflabs.com |
| Navidrome        |              nix-container (nixpkgs) |    https://music.raffauflabs.com |
| Plex             |       OCI: plexinc/pms-docker:public |     https://plex.raffauflabs.com |
| Audiobookshelf   |   OCI: advplyr/audiobookshelf:latest | https://podcasts.raffauflabs.com |
| Transmission     | OCI: linuxserver/transmission:latest |                          Tailnet |
| Jellyfin         |               OCI: jellyfin/jellyfin |                          Tailnet |
| Samba            |                              nixpkgs |                          Tailnet |
| Nginx            |                              nixpkgs |                                  |

## Deploying to NixOS
> :red_circle: **READ**: **Do not deploy this flake directly to your machine. It won't work.**
> This is my own [NixOS](https://nixos.org/) and [home-manager](https://github.com/nix-community/home-manager) flake for my personal devices.
> Each hardware-configuration is host-specific. If you fork this repository, replace them with the hardware-configuration.nix that NixOS generates for you.

### Enabling Flakes
While widely used and considered stable, [flakes](https://nixos.wiki/wiki/Flakes) are still considered experimental. To enable Flakes, add the following lines to your `configuration.nix` and rebuild.
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
### Building Flake
In order to deploy this Flake on your host, run the following command:
```
sudo nixos-rebuild boot --flake github:alyraffauf/nixcfg
```
Reboot to apply the flake's configuration for the chosen host.
