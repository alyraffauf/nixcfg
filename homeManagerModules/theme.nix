{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.theme.enable {
    home = {
      packages = with pkgs; [gnome.adwaita-icon-theme];

      pointerCursor = {
        gtk.enable = true;
        name = config.ar.home.theme.cursorTheme.name;
        package = config.ar.home.theme.cursorTheme.package;
        size = config.ar.home.theme.cursorTheme.size;

        x11 = {
          enable = true;
          defaultCursor = config.ar.home.theme.cursorTheme.name;
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };

    xdg.configFile = {
      "Kvantum/${config.ar.home.theme.qt.name}".source = "${config.ar.home.theme.qt.package}/share/Kvantum/${config.ar.home.theme.qt.name}";
      "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
        General.theme = config.ar.home.theme.qt.name;
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [config.ar.home.theme.terminalFont.name];
        serif = ["NotoSerif Nerd Font"];
        sansSerif = [config.ar.home.theme.font.name];
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = config.ar.home.theme.gtk.package;
        name = config.ar.home.theme.gtk.name;
      };

      iconTheme = {
        package = config.ar.home.theme.iconTheme.package;
        name = config.ar.home.theme.iconTheme.name;
      };

      font = {
        name = "${config.ar.home.theme.font.name} Regular";
        package = config.ar.home.theme.font.package;
        size = config.ar.home.theme.font.size;
      };

      gtk3.extraConfig = lib.attrsets.optionalAttrs (config.ar.home.theme.colors.preferDark) {gtk-application-prefer-dark-theme = 1;};

      gtk4.extraConfig = lib.attrsets.optionalAttrs (config.ar.home.theme.colors.preferDark) {gtk-application-prefer-dark-theme = 1;};

      # gtk3.extraCss =
      #   if config.ar.home.theme.gtk.hideTitleBar
      #   then ''
      #     /* No (default) title bar on wayland */
      #     headerbar.default-decoration {
      #       /* You may need to tweak these values depending on your GTK theme */
      #       margin-bottom: 50px;
      #       margin-top: -100px;

      #       background: transparent;
      #       padding: 0;
      #       border: 0;
      #       min-height: 0;
      #       font-size: 0;
      #       box-shadow: none;
      #     }

      #     /* rm -rf window shadows */
      #     window.csd,             /* gtk4? */
      #     window.csd decoration { /* gtk3 */
      #       box-shadow: none;
      #     }
      #   ''
      #   else "/* */";

      gtk3.extraCss = ''
        @define-color accent_bg_color ${config.ar.home.theme.colors.primary};

        @define-color accent_color @accent_bg_color; '';

      gtk4.extraCss = config.gtk.gtk3.extraCss;
    };

    dconf.settings = {
      "org/cinnamon/desktop/background".picture-uri = "file://${config.ar.home.theme.wallpaper}";

      "org/cinnamon/desktop/interface" = {
        cursor-size = config.ar.home.theme.cursorTheme.size;
        cursor-theme = config.ar.home.theme.cursorTheme.name;
        font-name = "${config.ar.home.theme.font.name} Regular ${toString config.ar.home.theme.font.size}";
        gtk-theme = config.ar.home.theme.gtk.name;
        icon-theme = config.ar.home.theme.iconTheme.name;
      };

      "org/cinnamon/theme".name = config.ar.home.theme.gtk.name;
      "org/cinnamon/desktop/wm/preferences".titlebar-font = "${config.ar.home.theme.font.name} ${toString config.ar.home.theme.font.size}";

      "org/gnome/desktop/background".picture-uri = "file://${config.ar.home.theme.wallpaper}";
      "org/gnome/desktop/background".picture-uri-dark = "file://${config.ar.home.theme.wallpaper}";
      "org/gnome/desktop/interface" = {
        color-scheme =
          if config.ar.home.theme.colors.preferDark
          then "prefer-dark"
          else "prefer-light";
        cursor-theme = config.ar.home.theme.cursorTheme.name;
        cursor-size = config.ar.home.theme.cursorTheme.size;
        gtk-theme = config.ar.home.theme.gtk.name;
        icon-theme = config.ar.home.theme.iconTheme.name;
        monospace-font-name = "${config.ar.home.theme.terminalFont.name} Regular ${toString config.ar.home.theme.terminalFont.size}";
      };

      "org/gnome/desktop/wm/preferences".titlebar-font = "${config.ar.home.theme.font.name} ${toString config.ar.home.theme.font.size}";
    };
  };
}
