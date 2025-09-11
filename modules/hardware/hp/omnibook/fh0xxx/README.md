# HP OmniBook Ultra Flip 14-fh0xx

## Usage

```nix
myHardware.hp.omnibook.fh0xxx.enable = true;
```

## What It Does

- **Graphics**: Uses xe driver on kernel 6.8+, disables PSR to fix screen flicker.
- **Audio**: Adds EasyEffects preset for better speaker sound.
- **Sensors**: Enables auto-rotate and tablet mode with Intel ISH firmware extracted from Widnows drivers.
- **Fingerprint**: Enables fprintd service.
- **Kernel**: Uses latest kernel if older than 6.16.

## Haptic Touchpad

Adjust haptic feedback strength:

```bash
sudo python3 adjust-haptics.py 75  # 0, 25, 50, 75, or 100
```
