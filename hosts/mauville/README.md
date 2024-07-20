# mauville
## Overview
Home lab/server built in a mini-ITX case from NZXT. Also used for gaming, but bottlenecked by the CPU. Home lab services are largely configured [upstream](https://github.com/alyraffauf/raffauflabs).

## Todo
- [ ] upgrade CPU.
- [ ] upgrade RAM to 32GB.
- [ ] add second 2TB SSD in btrfs pool.

## Specs
| Model   | Custom Mini-ITX Desktop   |
|---------|---------------------------|
| Display | LG 34" 3440x1440 160Hz VA |
| CPU     | AMD Ryzen 5 2600          |
| RAM     | 16GB (8GBx2) DDR4-3200Mhz |
| GPU     | AMD Radeon Rx 6700        |
| Disks   | 1TB M.2 PCIe 3.0          |
|         | 2TB SATA SSD              |
|         | 2TB SATA HDD              |

## Filesystems
### /
Encrypted LUKS btrfs volume. Can be unlocked remotely from initrd with authorized SSH keys.

### /mnt/Media
Main btrfs media storage volume for torrents, tv shows, movies, and other things served by audiobookshelf, navidrome, and plex.

Served over samba to my LAN as 'Media'.

### /mnt/Archive
Archival btrfs volume. Not used for anything important, just spillover for things not backed up to Backblaze.

Served over samba to my LAN as 'Archive'.

## Display
34" LG 34WP65C-B curved 3440 x 1440 160Hz ultrawide. Typically used at 1.25x scaling. 

## Services
| Service        | Description                       | Domain                           |
|----------------|-----------------------------------|----------------------------------|
| Audiobookshelf | Podcasts & audiobooks.            | https://podcasts.raffauflabs.com |
| Forĝejo        | Git & DevOps.                     | https://git.raffauflabs.com      |
| Navidrome      | SubSonic-compatible music server. | https://music.raffauflabs.com    |
| Plex           | Music, TV, and Movie streaming.   | https://plex.raffauflabs.com     |
| Transmission   | BitTorrent.                       | Tailnet/LAN                      |