{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.desktop.theme = {
      enable =
        lib.mkEnableOption "GTK and Qt themes.";
      gtk = {
        name = lib.mkOption {
          description = "GTK theme name.";
          default = "Catppuccin-Frappe-Compact-Mauve-Dark";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "GTK theme package.";
          default = pkgs.catppuccin-gtk.override {
            accents = ["mauve"];
            size = "compact";
            variant = "frappe";
            tweaks = ["normal"];
          };
          type = lib.types.package;
        };
        hideTitleBar = lib.mkOption {
          description = "Whether to hide GTK3/4 titlebars (useful for some window managers).";
          default = false;
          type = lib.types.bool;
        };
      };
      iconTheme = {
        name = lib.mkOption {
          description = "Icon theme name.";
          default = "Papirus-Dark";
          type = lib.types.str;
        };
        package = lib.mkOption {
          description = "Icon theme package.";
          default = pkgs.catppuccin-papirus-folders.override {
            flavor = "frappe";
            accent = "mauve";
          };
          type = lib.types.package;
        };
      };
      cursorTheme = {
        name = lib.mkOption {
          description = "Cursor theme name.";
          default = "Catppuccin-Frappe-Dark-Cursors";
          type = lib.types.str;
        };
        size = lib.mkOption {
          description = "Cursor size.";
          default = 24;
          type = lib.types.int;
        };
        package = lib.mkOption {
          description = "Cursor theme package.";
          default = pkgs.catppuccin-cursors.frappeDark;
          type = lib.types.package;
        };
      };
      font = {
        name = lib.mkOption {
          description = "Font name.";
          default = "NotoSans Nerd Font";
          type = lib.types.str;
        };
        size = lib.mkOption {
          description = "Font size.";
          default = 11;
          type = lib.types.int;
        };
        package = lib.mkOption {
          description = "Font package.";
          default = pkgs.nerdfonts.override {fonts = ["Noto"];};
          type = lib.types.package;
        };
      };
      terminalFont = {
        name = lib.mkOption {
          description = "Font name.";
          default = "NotoSansM Nerd Font";
          type = lib.types.str;
        };
        size = lib.mkOption {
          description = "Font size.";
          default = 11;
          type = lib.types.int;
        };
        package = lib.mkOption {
          description = "Font package.";
          default = pkgs.nerdfonts.override {fonts = ["Noto"];};
          type = lib.types.package;
        };
      };
      colors = {
        preferDark = lib.mkOption {
          description = "Whether to prefer dark mode apps or not.";
          default = config.alyraffauf.desktop.theme.enable;
          type = lib.types.bool;
        };
        text = lib.mkOption {
          description = "Text color.";
          default = "#FAFAFA";
          type = lib.types.str;
        };
        background = lib.mkOption {
          description = "Background color.";
          default = "#232634";
          type = lib.types.str;
        };
        primary = lib.mkOption {
          description = "Primary color.";
          default = "#CA9EE6";
          type = lib.types.str;
        };
        secondary = lib.mkOption {
          description = "Secondary color.";
          default = "#99D1DB";
          type = lib.types.str;
        };
        inactive = lib.mkOption {
          description = "Inactive color.";
          default = "#626880";
          type = lib.types.str;
        };
        shadow = lib.mkOption {
          description = "Drop shadow color.";
          default = "#1A1A1A";
          type = lib.types.str;
        };
      };
      wallpaper = lib.mkOption {
        description = "Default wallpaper.";
        default = "${config.xdg.dataHome}/backgrounds/jr-korpa-9XngoIpxcEo-unsplash.jpg";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.alyraffauf.desktop.theme.enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = config.alyraffauf.desktop.theme.cursorTheme.package;
      name = config.alyraffauf.desktop.theme.cursorTheme.name;
      size = config.alyraffauf.desktop.theme.cursorTheme.size;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "gtk2";
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [config.alyraffauf.desktop.theme.terminalFont.name];
        serif = ["NotoSerif Nerd Font"];
        sansSerif = [config.alyraffauf.desktop.theme.font.name];
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = config.alyraffauf.desktop.theme.gtk.package;
        name = config.alyraffauf.desktop.theme.gtk.name;
      };

      iconTheme = {
        package = config.alyraffauf.desktop.theme.iconTheme.package;
        name = config.alyraffauf.desktop.theme.iconTheme.name;
      };

      font = {
        name = "${config.alyraffauf.desktop.theme.font.name} Regular";
        package = config.alyraffauf.desktop.theme.font.package;
        size = config.alyraffauf.desktop.theme.font.size;
      };

      gtk3.extraConfig = lib.attrsets.optionalAttrs (config.alyraffauf.desktop.theme.colors.preferDark) {gtk-application-prefer-dark-theme = 1;};

      gtk4.extraConfig = lib.attrsets.optionalAttrs (config.alyraffauf.desktop.theme.colors.preferDark) {gtk-application-prefer-dark-theme = 1;};

      gtk3.extraCss =
        if config.alyraffauf.desktop.theme.gtk.hideTitleBar
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
        gtk-theme = config.alyraffauf.desktop.theme.gtk.name;
        color-scheme = "prefer-dark";
        cursor-theme = config.alyraffauf.desktop.theme.cursorTheme.name;
        cursor-size = config.alyraffauf.desktop.theme.cursorTheme.size;
      };
    };
  };
}
