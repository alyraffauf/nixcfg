# \*arr Profile

Complete \*arr stack for automated media management and downloading.

## Usage

```nix
{
  myNixOS.profiles.arr = {
    enable = true;
    dataDir = "/var/lib"; # optional, default location
  };
}
```

## What It Enables

- **Sonarr** (port 8989): TV show management and downloading.
- **Radarr** (port 7878): Movie management and downloading.
- **Lidarr** (port 8686): Music management and downloading.
- **Prowlarr** (port 9696): Indexer management for all \*arr services.
- **Bazarr** (port 6767): Subtitle management and downloading.

## Features

- **Unified data directory**: All services store data under configurable `dataDir`.
- **Firewall integration**: Automatically opens required ports for web interfaces.
- **Proper permissions**: Sets up correct directory ownership for each service.
- **Directory management**: Automatically creates required data directories.

## Default Ports

All services have their standard ports opened in the firewall for web UI access.
