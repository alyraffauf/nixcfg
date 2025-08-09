# Backups Profile

Automatic backup configuration for enabled services using Restic and Backblaze B2.

## Usage

```nix
{
  myNixOS.profiles.backups.enable = true;
}
```

## What It Does

- **Automatic detection**: Only backs up services that are actually enabled on the system.
- **Service management**: Stops services before backup, restarts them after completion.
- **Backblaze B2 storage**: All backups stored in `aly-backups` bucket with hostname separation.
- **Per-service repositories**: Each service gets its own restic repository for isolation.
- **Smart exclusions**: Excludes problematic paths (e.g., Plex database locks).

## Supported Services

- **Media**: Plex, Jellyfin, Audiobookshelf, Immich
- **\*arr stack**: Sonarr, Radarr, Lidarr, Prowlarr, Readarr, Bazarr
- **Development**: Forgejo (when not using external storage), PostgreSQL
- **Utilities**: qBittorrent, Uptime Kuma, Tautulli, Ombi
- **Smart home**: Homebridge
- **Security**: Vaultwarden
- **Other**: CouchDB, PDS (Bluesky)

## How It Works

1. **Conditional activation**: Backups only created for services enabled in your configuration.
2. **Safe stopping**: Services stopped gracefully before backup to ensure data consistency.
3. **Repository structure**: `rclone:b2:aly-backups/{hostname}/{service}` per service.
4. **Restic integration**: Uses `mySnippets.restic` configuration for default scheduling and retention settings.
