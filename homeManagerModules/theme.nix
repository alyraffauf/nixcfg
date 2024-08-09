{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home.theme;

  gtk = {
    extraConfig = lib.attrsets.optionalAttrs (cfg.darkMode) {gtk-application-prefer-dark-theme = 1;};

    extraCss = ''
      @define-color accent_bg_color ${cfg.colors.primary};
      @define-color accent_color @accent_bg_color;
      @define-color accent_fg_color ${cfg.colors.text};
      @define-color window_bg_color ${cfg.colors.background};
      @define-color window_fg_color ${cfg.colors.text};
      @define-color view_bg_color ${cfg.colors.background};
      @define-color view_fg_color @window_fg_color;
      @define-color headerbar_bg_color ${cfg.colors.background};
      @define-color headerbar_backdrop_color @window_bg_color;
      @define-color headerbar_fg_color @window_fg_color;

      @define-color popover_bg_color ${cfg.colors.background};
      @define-color popover_fg_color @view_fg_color;
      @define-color dialog_bg_color @popover_bg_color;
      @define-color dialog_fg_color @popover_fg_color;
      @define-color card_bg_color @popover_bg_color;
      @define-color card_fg_color @window_fg_color;
      @define-color sidebar_bg_color @headerbar_bg_color;
      @define-color sidebar_fg_color @window_fg_color;
      @define-color sidebar_backdrop_color @window_bg_color;
      @define-color sidebar_shade_color rgba(0,0,0,0.25);

        ${
        lib.strings.optionalString
        cfg.gtk.hideTitleBar
        ''
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
      }
    '';
  };
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        cfg.monospaceFont.package
        cfg.sansFont.package
        cfg.serifFont.package
        pkgs.adwaita-qt
        pkgs.gnome.adwaita-icon-theme
        pkgs.liberation_ttf
      ];

      pointerCursor = {
        gtk.enable = true;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = lib.mkDefault 24;

        x11 = {
          enable = true;
          defaultCursor = config.home.pointerCursor.name;
        };
      };
    };

    fonts.fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [cfg.monospaceFont.name];
        sansSerif = [cfg.sansFont.name];
        serif = [cfg.serifFont.name];
      };
    };

    gtk = {
      enable = true;

      theme = {
        name =
          if cfg.darkMode
          then "adw-gtk3-dark"
          else "adw-gtk3";

        package = pkgs.adw-gtk3;
      };

      font = {inherit (cfg.sansFont) name package size;};

      iconTheme = {
        name =
          if cfg.darkMode
          then "Papirus-Dark"
          else "Papirus";

        package = pkgs.papirus-icon-theme.override {color = "adwaita";};
      };

      gtk3 = {inherit (gtk) extraConfig extraCss;};
      gtk4 = {inherit (gtk) extraConfig extraCss;};
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";

      style = {
        name =
          if cfg.darkMode
          then "Adwaita-Dark"
          else "Adwaita";

        package = pkgs.adwaita-qt6;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${cfg.wallpaper}";
        picture-uri-dark = "file://${cfg.wallpaper}";
      };

      "org/gnome/desktop/interface" = {
        color-scheme =
          if cfg.darkMode
          then "prefer-dark"
          else "prefer-light";

        document-font-name = "${cfg.serifFont.name} ${toString cfg.serifFont.size}";
        monospace-font-name = "${cfg.monospaceFont.name} ${toString cfg.monospaceFont.size}";
      };

      "org/gnome/desktop/wm/preferences".titlebar-font = "${cfg.sansFont.name} ${toString cfg.sansFont.size}";
    };
  };
}
