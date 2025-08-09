# Lenovo ThinkPad T440p

## Audio Enhancement

Includes an EasyEffects preset to significantly improve the notoriously poor speaker quality:

- **30-band equalizer** - Custom frequency response tuning.
- **Harmonic exciter** - Adds presence and clarity to muddy speakers.
- **Auto-gain and limiting** - Prevents distortion while maximizing volume.

The preset is automatically configured through home-manager when the module is enabled.

```nix
myHardware.lenovo.thinkpad.T440p.enable = true;
```

## Performance Tweaks

- **CPU governor** - Set to `ondemand` for balanced performance/power on older hardware. For some reason, it's performance by default, even on battery.
- **ZRAM compression** - Uses fast `lz4` algorithm for better swap performance.
