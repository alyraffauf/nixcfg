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
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = lib.mkDefault 20;

        x11 = {
          enable = true;
          defaultCursor = config.home.pointerCursor.name;
        };
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["NotoSansM Nerd Font"];
        serif = ["NotoSerif Nerd Font"];
        sansSerif = [config.gtk.font.name];
      };
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.adw-gtk3;
        name =
          if config.ar.home.theme.darkMode
          then "adw-gtk3-dark"
          else "adw-gtk3";
      };

      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name =
          if config.ar.home.theme.darkMode
          then "Papirus-Dark"
          else "Papirus";
      };

      font = {
        name = "NotoSans Nerd Font";
        package = pkgs.nerdfonts;
        size = lib.mkDefault 11;
      };

      gtk3.extraConfig = lib.attrsets.optionalAttrs (config.ar.home.theme.darkMode) {gtk-application-prefer-dark-theme = 1;};

      gtk4.extraConfig = lib.attrsets.optionalAttrs (config.ar.home.theme.darkMode) {gtk-application-prefer-dark-theme = 1;};

      gtk3.extraCss = ''
        @define-color accent_bg_color ${config.ar.home.theme.colors.primary};
        @define-color accent_color @accent_bg_color;

        ${
          lib.strings.optionalString
          config.ar.home.theme.gtk.hideTitleBar
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

      gtk4.extraCss = config.gtk.gtk3.extraCss;
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style = {
        package = pkgs.adwaita-qt;
        name =
          if config.ar.home.theme.darkMode
          then "Adwaita Dark"
          else "Adwaita";
      };
    };

    dconf.settings = {
      "org/cinnamon/desktop/background".picture-uri = "file://${config.ar.home.theme.wallpaper}";

      "org/cinnamon/desktop/interface" = {
        cursor-size = config.home.pointerCursor.size;
        cursor-theme = config.home.pointerCursor.name;
        font-name = "${config.gtk.font.name} Regular ${toString config.gtk.font.size}";
        gtk-theme =
          if config.ar.home.theme.darkMode
          then "adw-gtk3-dark"
          else "adw-gtk3";
        icon-theme =
          if config.ar.home.theme.darkMode
          then "Papirus-Dark"
          else "Papirus";
      };

      "org/cinnamon/theme".name =
        if config.ar.home.theme.darkMode
        then "adw-gtk3-dark"
        else "adw-gtk3";

      "org/cinnamon/desktop/wm/preferences".titlebar-font = "${config.gtk.font.name} Regular ${toString config.gtk.font.size}";

      "org/gnome/desktop/background".picture-uri = "file://${config.ar.home.theme.wallpaper}";
      "org/gnome/desktop/background".picture-uri-dark = "file://${config.ar.home.theme.wallpaper}";

      "org/gnome/desktop/interface" = {
        color-scheme =
          if config.ar.home.theme.darkMode
          then "prefer-dark"
          else "prefer-light";

        cursor-theme = config.home.pointerCursor.name;
        cursor-size = config.home.pointerCursor.size;

        gtk-theme =
          if config.ar.home.theme.darkMode
          then "adw-gtk3-dark"
          else "adw-gtk3";

        icon-theme =
          if config.ar.home.theme.darkMode
          then "Papirus-Dark"
          else "Papirus";
        monospace-font-name = "NotoSansM Nerd Font Regular ${toString config.gtk.font.size}";
      };

      "org/gnome/desktop/wm/preferences".titlebar-font = "${config.gtk.font.name} Regular ${toString config.gtk.font.size}";
    };
  };
}
