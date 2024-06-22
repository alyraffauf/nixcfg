{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.cinnamon.enable {
    alyraffauf = {
      apps = {
        nemo.enable = lib.mkDefault true;
      };
    };
    dconf = {
      enable = true;
      settings = {
        "org/cinnamon/desktop/background".picture-uri = "file://${config.alyraffauf.theme.wallpaper}";
        "org/cinnamon/desktop/interface".cursor-size = config.alyraffauf.theme.cursorTheme.size;
        "org/cinnamon/desktop/interface".cursor-theme = config.alyraffauf.theme.cursorTheme.name;
        "org/cinnamon/desktop/interface".font-name = "${config.alyraffauf.theme.font.name} Regular ${toString config.alyraffauf.theme.font.size}";
        "org/cinnamon/desktop/interface".gtk-theme = config.alyraffauf.theme.gtk.name;
        "org/cinnamon/desktop/interface".icon-theme = config.alyraffauf.theme.iconTheme.name;
        "org/cinnamon/desktop/wm/preferences".titlebar-font = "${config.alyraffauf.theme.font.name} ${toString config.alyraffauf.theme.font.size}";
        "org/cinnamon/gestures".enabled = true;
        "org/cinnamon/muffin".workspace-cycle = true;
        "org/cinnamon/muffin".workspaces-only-on-primary = true;
        "org/cinnamon/settings-daemon/peripherals/touchscreen".orientation-lock = false;
        "org/cinnamon/theme".name = config.alyraffauf.theme.gtk.name;
        "org/gnome/desktop/interface".gtk-theme = config.alyraffauf.theme.gtk.name;
        "org/gnome/desktop/interface".cursor-size = config.alyraffauf.theme.cursorTheme.size;
        "org/gnome/desktop/interface".cursor-theme = config.alyraffauf.theme.cursorTheme.name;
        "org/gnome/desktop/interface".icon-theme = config.alyraffauf.theme.iconTheme.name;
        "org/gnome/desktop/interface".monospace-font-name = "${config.alyraffauf.theme.terminalFont.name} Regular ${toString config.alyraffauf.theme.terminalFont.size}";
        "org/gnome/desktop/peripherals/touchpad".natural-scroll = true;
        "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        "org/gnome/desktop/wm/preferences".titlebar-font = "${config.alyraffauf.theme.font.name} ${toString config.alyraffauf.theme.font.size}";
        "org/nemo/desktop".font = "${config.alyraffauf.theme.font.name} ${toString config.alyraffauf.theme.font.size}";
        "org/cinnamon/desktop/wm/preferences" = {
          focus-mode = "mouse";
          mouse-button-modifier = "<Super>";
        };
        "org/gnome/desktop/wm/preferences" = {
          focus-mode = "mouse";
          mouse-button-modifier = "<Super>";
        };
        "org/cinnamon/muffin".attach-modal-dialogs = true;
        "org/cinnamon/desktop/keybindings/media-keys" = {
          www = ["XF86WWW" "<Super>b"];
          terminal = ["<Primary><Alt>" "<Super>t"];
        };
        "org/cinnamon/desktop/keybindings/wm" = {
          # TODO: Declaratively disable conflict with panel applet.
          close = ["<Alt>F4" "<Super>c"];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-8 = ["<Super>8"];
          switch-to-workspace-9 = ["<Super>9"];
        };
      };
    };
  };
}
