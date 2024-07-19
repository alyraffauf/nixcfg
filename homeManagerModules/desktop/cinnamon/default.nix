{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.cinnamon.enable {
    dconf = {
      enable = true;
      settings = {
        "org/cinnamon/desktop/peripherals/touchpad".click-method = "fingers";
        "org/cinnamon/gestures".enabled = true;

        "org/cinnamon/muffin" = {
          attach-modal-dialogs = true;
          workspace-cycle = true;
          workspaces-only-on-primary = true;
        };

        "org/cinnamon/desktop/interface".clock-use-24h = false;

        "org/gnome/desktop/interface".clock-format = "12h";

        "org/cinnamon/settings-daemon/peripherals/touchscreen".orientation-lock = false;

        "org/gnome/desktop/peripherals/touchpad" = {
          natural-scroll = true;
          tap-to-click = true;
        };

        "org/gnome/desktop/wm/preferences" = {
          focus-mode = "mouse";
          mouse-button-modifier = "<Super>";
        };

        "org/cinnamon/desktop/keybindings/media-keys" = {
          www = ["XF86WWW" "<Super>b"];
          terminal = ["<Primary><Alt>" "<Super>t"];
          home = ["<Super>f" "XF86Explorer"];
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

        "org/cinnamon/desktop/keybindings".custom-list = ["__dummy__" "custom0"];

        "org/cinnamon/desktop/keybindings/custom-keybindings/custom0" = {
          binding = ["<Super>e"];
          name = "Open Editor";
          command = "${lib.getExe config.ar.home.defaultApps.editor}";
        };
      };
    };
  };
}
