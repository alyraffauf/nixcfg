# 🖥️ Mauville

## Overview

Beelink Mini S12 Pro, serving as a reliable home server and lightweight NAS for media and storage needs.

---

## Specs

| Component  | Details                   |
| ---------- | ------------------------- |
| **Model**  | Beelink Mini S12 Pro      |
| **CPU**    | Intel N100                |
| **RAM**    | 16GB (2x8GB) DDR4-3200MHz |
| **Disk 1** | 512GB M.2 SATA SSD        |
| **Disk 2** | 2TB SATA SSD              |

---

## 🗂 Filesystems

### `/` (Root)

- **Format**: Btrfs.
- **Encryption**: Encrypted with LUKS for security.

### `/mnt/Media`

- **Format**: Btrfs.
- **Purpose**: Main storage for media files, including torrents, TV shows, movies, and more.
- **Access**: Shared over LAN via Samba as `Media`.
- **Used By**:
  - **Audiobookshelf**: Podcasts & audiobooks.
  - **Navidrome**: Music streaming.
  - **Plex**: TV, movie, and music streaming.

---

## 📡 Services

| Service            | Description                      | Domain                                                       |
| ------------------ | -------------------------------- | ------------------------------------------------------------ |
| **Audiobookshelf** | Podcasts & audiobooks            | [podcasts.raffauflabs.com](https://podcasts.raffauflabs.com) |
| **Navidrome**      | SubSonic-compatible music server | [music.raffauflabs.com](https://music.raffauflabs.com)       |
| **Plex**           | Music, TV, and movie streaming   | [plex.raffauflabs.com](https://plex.raffauflabs.com)         |
| **Transmission**   | BitTorrent                       | Tailnet/LAN                                                  |

---
