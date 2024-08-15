{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home.theme;

  gtk = {
    extraCss =
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
      '';
  };
in {
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        pkgs.adwaita-qt
        pkgs.gnome.adwaita-icon-theme
        pkgs.liberation_ttf
      ];
    };

    gtk = {
      iconTheme = {
        name =
          if cfg.darkMode
          then "Papirus-Dark"
          else "Papirus";

        package = pkgs.papirus-icon-theme.override {color = "adwaita";};
      };

      gtk3 = {inherit (gtk) extraCss;};
      gtk4 = {inherit (gtk) extraCss;};
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
  };
}
