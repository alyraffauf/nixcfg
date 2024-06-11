{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.theme.enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = config.alyraffauf.theme.cursorTheme.name;
      };
      name = config.alyraffauf.theme.cursorTheme.name;
      package = config.alyraffauf.theme.cursorTheme.package;
      size = config.alyraffauf.theme.cursorTheme.size;
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/${config.alyraffauf.theme.qt.name}".source = "${config.alyraffauf.theme.qt.package}/share/Kvantum/${config.alyraffauf.theme.qt.name}";
      "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
        General.theme = config.alyraffauf.theme.qt.name;
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [config.alyraffauf.theme.terminalFont.name];
        serif = ["NotoSerif Nerd Font"];
        sansSerif = [config.alyraffauf.theme.font.name];
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = config.alyraffauf.theme.gtk.package;
        name = config.alyraffauf.theme.gtk.name;
      };

      iconTheme = {
        package = config.alyraffauf.theme.iconTheme.package;
        name = config.alyraffauf.theme.iconTheme.name;
      };

      font = {
        name = "${config.alyraffauf.theme.font.name} Regular";
        package = config.alyraffauf.theme.font.package;
        size = config.alyraffauf.theme.font.size;
      };

      gtk3.extraConfig = lib.attrsets.optionalAttrs (config.alyraffauf.theme.colors.preferDark) {gtk-application-prefer-dark-theme = 1;};

      gtk4.extraConfig = lib.attrsets.optionalAttrs (config.alyraffauf.theme.colors.preferDark) {gtk-application-prefer-dark-theme = 1;};

      gtk3.extraCss =
        if config.alyraffauf.theme.gtk.hideTitleBar
        then ''
          /* No (default) title bar on wayland */
          headerbar.default-decoration {
            /* You may need to tweak these values depending on your GTK theme */
            margin-bottom: 50px;
            margin-top: -100px;

            background: transparent;
            padding: 0;
            border: 0;
            min-height: 0;
            font-size: 0;
            box-shadow: none;
          }

          /* rm -rf window shadows */
          window.csd,             /* gtk4? */
          window.csd decoration { /* gtk3 */
            box-shadow: none;
          }
        ''
        else "/* */";

      gtk4.extraCss = config.gtk.gtk3.extraCss;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = config.alyraffauf.theme.gtk.name;
        color-scheme = "prefer-dark";
        cursor-theme = config.alyraffauf.theme.cursorTheme.name;
        cursor-size = config.alyraffauf.theme.cursorTheme.size;
      };
    };
  };
}
