{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.cinnamon.enable =
      lib.mkEnableOption "Cinnamon with sane defaults.";
  };

  config = lib.mkIf config.alyraffauf.desktop.cinnamon.enable {
    dconf.enable = true;
    dconf.settings = {
      "org/cinnamon/desktop/background".picture-uri = "file://${config.alyraffauf.desktop.theme.wallpaper}";
      "org/cinnamon/desktop/interface".cursor-size = config.alyraffauf.desktop.theme.cursorTheme.size;
      "org/cinnamon/desktop/interface".cursor-theme = config.alyraffauf.desktop.theme.cursorTheme.name;
      "org/cinnamon/desktop/interface".font-name = "${config.alyraffauf.desktop.theme.font.name}-Regular ${toString config.alyraffauf.desktop.theme.font.size}";
      "org/cinnamon/desktop/interface".gtk-theme = config.alyraffauf.desktop.theme.gtk.name;
      "org/cinnamon/desktop/interface".icon-theme = config.alyraffauf.desktop.theme.iconTheme.name;
      "org/cinnamon/desktop/wm/preferences".titlebar-font = "${config.alyraffauf.desktop.theme.font.name} ${toString config.alyraffauf.desktop.theme.font.size}";
      "org/cinnamon/gestures".enabled = true;
      "org/cinnamon/muffin".workspace-cycle = true;
      "org/cinnamon/muffin".workspaces-only-on-primary = true;
      "org/cinnamon/settings-daemon/peripherals/touchscreen".orientation-lock = false;
      "org/cinnamon/theme".name = config.alyraffauf.desktop.theme.gtk.name;      "org/gnome/desktop/interface".gtk-theme = config.alyraffauf.desktop.theme.gtk.name;
      "org/gnome/desktop/interface".cursor-size = config.alyraffauf.desktop.theme.cursorTheme.size;
      "org/gnome/desktop/interface".cursor-theme = config.alyraffauf.desktop.theme.cursorTheme.name;
      "org/gnome/desktop/interface".icon-theme = config.alyraffauf.desktop.theme.iconTheme.name;
      "org/gnome/desktop/interface".monospace-font-name = "${config.alyraffauf.desktop.theme.terminalFont.name} ${toString config.alyraffauf.desktop.theme.terminalFont.size}";
      "org/gnome/desktop/peripherals/touchpad".natural-scroll = true;
      "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
      "org/gnome/desktop/wm/preferences".titlebar-font = "${config.alyraffauf.desktop.theme.font.name} ${toString config.alyraffauf.desktop.theme.font.size}";
      "org/nemo/desktop".font = "${config.alyraffauf.desktop.theme.font.name} ${toString config.alyraffauf.desktop.theme.font.size}";
    };
  };
}
