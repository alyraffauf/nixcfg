# qBittorrent Module

NixOS module for qBittorrent's headless (nox) version.

_Adapted graciously from [WiredMic's nix-config](https://github.com/WiredMic/nix-config/commit/d9268ce5190a2041ef66b492900eed278d1508e2)_

## Usage

```nix
{
  myNixOS.services.qbittorrent = {
    enable = true;
    port = 8080;
    dataDir = "/var/lib/qbittorrent";
    openFirewall = false;
  };
}
```

## Options

- `port`: Web UI port (default: 8080)
- `dataDir`: Data storage directory (default: `/var/lib/qbittorrent`)
- `user`/`group`: Service user/group (default: `qbittorrent`)
- `openFirewall`: Open port in firewall (default: false)
