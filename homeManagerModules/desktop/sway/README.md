# Sway

## Features

- Clamshell mode for laptops
- Default apps + theme integration
- Random wallpapers that cycle every 15 minutes
- Slick looks
- swayfx support

## Desktop Utilities

- Bluetooth: [blueman](https://github.com/blueman-project/blueman).
- Idle daemon: [swayidle](https://github.com/swaywm/swayidle).
- Launcher [rofi-wayland](https://github.com/lbonn/rofi).
- Notifications: [mako](https://github.com/emersion/mako).
- Panel: [waybar](https://github.com/Alexays/Waybar).
- Polkit: [mate-polkit](https://github.com/mate-desktop/mate-polkit).
- Wallpapers: [swaybg](https://github.com/swaywm/swaybg).
- WiFi: [network-manager-applet](https://gitlab.gnome.org/GNOME/network-manager-applet).

## Keybindings

### Launching Apps

- SUPER + B: Open Browser.
- SUPER + E: Open Text Editor.
- SUPER + F: Open File Manager.
- SUPER + R: Open Launcher.
- SUPER + T: Open Terminal.

### Screenshots

- PRINT // CTRL + F12: Take screenshot of monitor or selected area.

### Session Control

- SUPER CTRL + L: Lock screen.
- SUPER + M: Logout/shutdown dialog.

### Workspaces

#### Switching Workspaces

- SUPER + {1..9}: Switch to numbered workspace.
- SUPER + Comma: Switch to previous numbered workspace.
- SUPER + Period: Switch to next numbered workspace.
- TOUCHPAD: 3 Finger Swipe Left/Right.

#### Multi-Monitor Workspace Management

- SUPER CTRL SHIFT + Down: Move current workspace to monitor below.
- SUPER CTRL SHIFT + Up: Move current workspace to monitor above.
- SUPER CTRL SHIFT + Left: Move current workspace to monitor left.
- SUPER CTRL SHIFT + Right: Move current workspace to monitor right.

______________________________________________________________________

- SUPER CTRL SHIFT + J: Move current workspace to monitor below.
- SUPER CTRL SHIFT + K: Move current workspace to monitor above.
- SUPER CTRL SHIFT + H: Move current workspace to monitor left.
- SUPER CTRL SHIFT + L: Move current workspace to monitor right.

### Window Management

- SUPER + C: Kill focused window.
- SUPER SHIFT + W: Toggle fullscreen.
- SUPER + V: Toggle floating window.
- SUPER + F11: Show/hide top panel.

#### Focus

- SUPER + Down: Change focus down.
- SUPER + Up: Change focus up.
- SUPER + Left: Change focus left.
- SUPER + Right: Change focus right.

______________________________________________________________________

- SUPER + J: Change focus down.
- SUPER + K: Change focus up.
- SUPER + H: Change focus left.
- SUPER + L: Change focus right.

#### Movement

- SUPER SHIFT + Down: Move window down.
- SUPER SHIFT + Up: Move window up.
- SUPER SHIFT + Left: Move window left.
- SUPER SHIFT + Right: Move window right.

______________________________________________________________________

- SUPER SHIFT + J: Move window down.
- SUPER SHIFT + K: Move window up.
- SUPER SHIFT + H: Move window left.
- SUPER SHIFT + L: Move window right.

#### Moving between Workspaces

- SUPER SHIFT + {1..9}: Move to specified numbered workspace.
- SUPER SHIFT + Comma: Move to previous numbered workspace.
- SUPER SHIFT + Period: Move to next numbered workspace.

#### Scratchpad

- SUPER + S: Switch to scratchpad (overlay).
- SUPER SHIFT + S: Move window to scratchpad.

### Modes

These modes provide special submaps where you are free to use various key binds without pressing the full key combo, because certain keys are assumed.

#### Resize Mode

- CTRL ALT + R: Enter resize mode.

  - Down: Resize active window (0,10).
  - Up: Resize active window (0,-10)
  - Left: Resize active window (-10,0).
  - Right: Resize active window (10,0).

  ______________________________________________________________________

  - J: Resize active window (0,10).
  - K: Resize active window (0,-10)
  - H: Resize active window (-10,0).
  - L: Resize active window (10,0).

- ESCAPE: Exit resize mode.

#### Move Mode

- CTRL ALT + M: Enter move mode.

  - {1..0}: Move to numbered workspace.
  - Comma: Move to previous numbered workspace.
  - Period: Move to next numbered workspace.

  ______________________________________________________________________

  - Down: Move window down.
  - Up: Move window up.
  - Left: Move window left.
  - Right: Move window right.

  ______________________________________________________________________

  - J: Move window down.
  - K: Move window up.
  - H: Move window left.
  - L: Move window right.

- ESCAPE: Exit move mode.
