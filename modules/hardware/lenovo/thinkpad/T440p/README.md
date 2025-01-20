# Lenovo ThinkPad T440p

Optimized nix modules for Lenovo T440p hardware.

______________________________________________________________________

## Audio

- **Workaround**: Terrible speaker quality.
  - Speakers can be improved significantly with an EasyEffects preset: [`T440p.json`](./easyeffects.json).

______________________________________________________________________

## Platform

- Kernel module `thinkpad_acpi` is forc-loaded with specific options:
  - `force_load=1`: Ensures the module loads even if not automatically detected, providing access to ThinkPad-specific hardware controls.
  - `fan_control=1`: Enables manual control over fan speeds, allowing users to adjust cooling behavior and reduce noise or manage thermals more effectively.

______________________________________________________________________
