# Server Profile

NixOS profile optimized for headless server environments.

## Usage

```nix
{
  myNixOS.profiles.server.enable = true;
}
```

## What It Does

- **Minimal footprint**: Disables documentation and reduces system overhead.
- **Log management**: Volatile journald storage with 32MB limits to preserve disk space.
- **File monitoring**: Optimized inotify limits for server workloads.
- **Memory management**: ZRAM swap with zstd compression for efficiency.
- **Security**: Automatic fail2ban protection against brute force attacks.
- **Performance tuning**: BPF-based automatic kernel tuning.
- **Reliability**: systemd-oomd for out-of-memory protection.

## Important Notes

Disables coredumps and emergency mode for unattended operation.
