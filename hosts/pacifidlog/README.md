# pacifidlog

## Overview

Lenovo Legion Go with AMD Z1 Extreme. Gaming beast. Uses Jovian for Steam Deck-like interface.

## Todo

- \[x\] update hdd-ui and adjustor.
- \[ \] upgrade to large SSD.

## Specs

| Model   | Legion Go                 |
|---------|---------------------------|
| Display | 8.8" 1600x2560 144Hz      |
| CPU     | AMD Z1 Extreme            |
| RAM     | 16GB LPDDR5 (soldered)    |
| GPU     | AMD Z1 Extreme            |
| Disks   | 512GB M.2 2242 NVMe       |

## Filesystems

### /

Encrypted LUKS btrfs volume.

## Display

Vertical-turned-horizontal 1600x2560 display running at 144Hz. Scales perfectly to 2x.

## Steam / Jovian Docs

Jovian delivers a Steam Deck-like interface on top of NixOS, with some limitations. This includes performance optimizations, patched versions of Mesa, and other tweaks to be as consistent with the Steam Deck as possible.

### Features

#### What works

- Basic performance settings (frame limits, refresh rates, etc).
- Desktop mode with KDE.
- Installing GOG and EGS games with Heroic.
- Launching and playing games, natively and with Proton.
- Plugins and themes with Decky Loader.

#### What does not work

- Adaptive Brightness.
- EmuDeck.
- Formatting microSD cards.
- Night light.
- System updates.
- TDP control and Legion Go specific features (all work with Handheld Daemon).

### Decky Loader

Decky loader can be installed and configured through the Jovian modules, but needs CEF Remote Debugging enabled via Deveroper Options for the frontend UI to load.
