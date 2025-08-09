# Auto Upgrade Profile

Automatic system updates from the flake repository.

## Usage

```nix
{
  myNixOS.profiles.autoUpgrade = {
    enable = true;
    operation = "boot"; # or "switch" or "test"
  };
}
```

## What It Does

- **Scheduled updates**: Daily updates at 2:00 AM with up to 120 minutes random delay.
- **Flake integration**: Updates from `github:alyraffauf/nixcfg` (or configured `FLAKE` variable).
- **Reboot window**: Automatic reboots only between 2:00-6:00 AM.
- **Network check**: Tests connectivity before attempting updates.
- **Retry logic**: Retries failed updates (useful for laptops that wake without network).
- **Persistent timers**: Updates survive system reboots and sleep cycles and begin when possible.

## Important Notes

Enables automatic reboots by default during the 2:00-6:00 AM window.
