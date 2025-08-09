# Lenovo ThinkPad X1 Carbon Gen 9

## Audio Enhancement

This module includes a custom PipeWire filter chain that significantly improves speaker quality:

- **Bass enhancement** - Psychoacoustic processing adds missing low frequencies
- **Loudness compensation** - Maintains consistent sound across volume levels
- **Custom equalizer** - 8-band EQ tuned for laptop speakers
- **Dynamic compression** - Smooths audio for better speaker performance

Creates a virtual "ThinkPad Speakers" device that processes all audio.

### Usage

```nix
myHardware.lenovo.thinkpad.X1.gen-9 = {
  enable = true;
  equalizer.enable = true;  # Enable audio processing
};
```

### Notes

- Before enabling the equalizer, set speaker volume to 100% (filter-chain creates a fake audio output that handles volume control)
- May need to select "ThinkPad Speakers" as default output device

### Credits

Filter chain adapted from the [nixos-hardware Framework Laptop audio configuration](https://github.com/NixOS/nixos-hardware/blob/master/framework/13-inch/common/audio.nix).
