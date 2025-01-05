# lilycove

## Overview

Gaming desktop built in a mini-ITX case from NZXT (bleh).

## Todo

- \[x\] upgrade CPU.
- \[x\] upgrade RAM to 32GB.

## Specs

| Model   | Custom Mini-ITX Desktop   |
|---------|---------------------------|
| Display | LG 34" 3440x1440 160Hz VA |
| CPU     | AMD Ryzen 5 5600GT        |
| RAM     | 32GB (16GBx2) DDR4-3200Mhz|
| GPU     | AMD Radeon Rx 6700        |
| Disks   | 1TB M.2 PCIe 3.0          |
|         | 2TB SATA HDD              |

## Filesystems

### /

Encrypted LUKS btrfs volume. Can be unlocked remotely from initrd with authorized SSH keys.

### /mnt/Archive

Archival btrfs volume. Served over samba to my LAN as 'Archive'.

## Display

34" LG 34WP65C-B curved 3440 x 1440 160Hz ultrawide. Typically used at 1.0x scaling.
