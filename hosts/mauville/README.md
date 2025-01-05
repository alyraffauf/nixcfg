# mauville

## Overview

Beelink Mini S12 Pro. Operates as a home server and simple NAS.

## Todo\\

## Specs

| Model   | Custom Mini-ITX Desktop   |
|---------|---------------------------|
| CPU     | Intel N100                |
| RAM     | 16GB (8GBx2) DDR4-3200Mhz |
| Disks   | 512GB M.2 SATA SSD        |
|         | 2TB SATA SSD              |

## Filesystems

### /

Encrypted LUKS btrfs volume.

### /mnt/Media

Main btrfs media storage volume for torrents, tv shows, movies, and other things served by audiobookshelf, navidrome, and plex.

Served over samba to my LAN as 'Media'.

## Services

| Service        | Description                       | Domain                           |
|----------------|-----------------------------------|----------------------------------|
| Audiobookshelf | Podcasts & audiobooks.            | https://podcasts.raffauflabs.com |
| Navidrome      | SubSonic-compatible music server. | https://music.raffauflabs.com    |
| Plex           | Music, TV, and Movie streaming.   | https://plex.raffauflabs.com     |
| Transmission   | BitTorrent.                       | Tailnet/LAN                      |
