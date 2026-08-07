# Btrfs Profile

Btrfs filesystem management with snapshots, scrubbing, and optional deduplication.

## Usage

```nix
{
  myNixOS.profiles.btrfs = {
    enable = true;
    deduplicate = false; # optional, enables beesd
  };
}
```

## What It Does

- **Filesystem support**: Enables btrfs kernel support.
- **Auto-scrubbing**: Periodic data integrity checks on all btrfs filesystems.
- **Snapshots**: Automatic timeline snapshots of `/home` with snapper (if btrfs subvolume).
- **Smart filtering**: Excludes cache, config, and temporary files from snapshots.
- **Deduplication**: Optional beesd for block-level deduplication (when enabled).
- **GUI tools**: Includes snapper-gui on desktop systems.

## Snapshot Configuration

- **Timeline snapshots**: Automatic creation and cleanup enabled.
- **User access**: Users group can manage their own snapshots.
- **Filtered paths**: Excludes `.cache`, `.config`, `.local`, browser profiles, etc.

## Deduplication (Optional)

When `deduplicate = true`:

- **beesd**: Runs with 2GB hash tables and conservative load targets.
- **Performance tuning**: Limited to 50% thread factor and 1.0 load average.
- **Auto-discovery**: Automatically configures all detected btrfs devices.

## Important Notes

Only activates features for detected btrfs filesystems. Snapper only configured if `/home` is a btrfs subvolume.
