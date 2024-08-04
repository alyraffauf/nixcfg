{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home.theme;
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["UbuntuSans"];})
        adwaita-qt
        gnome.adwaita-icon-theme
        liberation_ttf
        vegur
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
        monospace = ["UbuntuSansMono Nerd Font" "Liberation Mono"];
        serif = ["Vegur" "Liberation Serif"];
        sansSerif = [config.gtk.font.name "LIberation Sans"];
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.adw-gtk3;
        name =
          if cfg.darkMode
          then "adw-gtk3-dark"
          else "adw-gtk3";
      };

      iconTheme = {
        package = pkgs.papirus-icon-theme.override {color = "adwaita";};
        name =
          if cfg.darkMode
          then "Papirus-Dark"
          else "Papirus";
      };

      font = {
        name = "UbuntuSans Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["UbuntuSans"];};
        size = lib.mkDefault 11;
      };

      gtk3 = {
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

      gtk4 = {
        extraConfig = lib.attrsets.optionalAttrs (cfg.darkMode) {gtk-application-prefer-dark-theme = 1;};
        extraCss = config.gtk.gtk3.extraCss;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
        package = pkgs.adwaita-qt6;
        name =
          if cfg.darkMode
          then "Adwaita-Dark"
          else "Adwaita";
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

        cursor-theme = config.home.pointerCursor.name;
        cursor-size = config.home.pointerCursor.size;

        document-font-name = "Vegur ${toString config.gtk.font.size}";

        gtk-theme =
          if cfg.darkMode
          then "adw-gtk3-dark"
          else "adw-gtk3";

        icon-theme =
          if cfg.darkMode
          then "Papirus-Dark"
          else "Papirus";

        monospace-font-name = "UbuntuSansMono Nerd Font ${toString config.gtk.font.size}";
      };

      "org/gnome/desktop/wm/preferences".titlebar-font = "${config.gtk.font.name} ${toString config.gtk.font.size}";
    };
  };
}
