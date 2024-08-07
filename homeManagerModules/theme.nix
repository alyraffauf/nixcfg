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

  font = {
    name = "UbuntuSans Nerd Font";
    package = pkgs.nerdfonts.override {fonts = ["UbuntuSans"];};
    size = 11;
  };

  monospaceFont = {
    inherit (font) package size;
    name = "UbuntuSansMono Nerd Font";
  };

  serifFont = {
    inherit (font) size;
    name = "Vegur";
    package = pkgs.vegur;
  };
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        font.package
        monospaceFont.package
        pkgs.adwaita-qt
        pkgs.gnome.adwaita-icon-theme
        pkgs.liberation_ttf
        serifFont.package
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
        monospace = [monospaceFont.name];
        sansSerif = [font.name];
        serif = [serifFont.name];
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

      font = {inherit (font) name package size;};

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

        document-font-name = "${serifFont.name} ${toString serifFont.size}";
        monospace-font-name = "${monospaceFont.name} ${toString monospaceFont.size}";
      };

      "org/gnome/desktop/wm/preferences".titlebar-font = "${font.name} ${toString font.size}";
    };
  };
}
