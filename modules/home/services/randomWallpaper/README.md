# randomWallpaperD

Dynamically sets per-monitor wallpapers and changes them on a 30 minute timer. Running as a daemon, this script supports monitor hotplugging by polling the window manager for active outputs, then intelligently assigns random wallpapers per-screen with [swaybg](https://github.com/swaywm/swaybg).

## Arguments

If called without arguments, it assumes wallpapers are in a directory `~/.local/share/backgrounds`. The first argument can be used to set the directory:

```bash
./script.rb ~/path/to/my/wallpapers
```

## Window Manager Support

Because this script polls the window manager directly by way of its CLI utility, it currently only supports Hyprland (with `hyprctl`) and Sway (with `swaymsg`).
