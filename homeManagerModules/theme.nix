{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home.theme;
in {
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome.adwaita-icon-theme
      pkgs.liberation_ttf
    ];

    gtk.iconTheme = {
      name =
        if config.stylix.polarity == "dark"
        then "Papirus-Dark"
        else "Papirus";

      package = pkgs.papirus-icon-theme.override {color = "adwaita";};
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";

      style = {
        name =
          if config.stylix.polarity == "dark"
          then "Adwaita-Dark"
          else "Adwaita";

        package = pkgs.adwaita-qt;
      };
    };

    stylix.targets.gtk.extraCss = ''
      // Control rounded corners
      window.background { border-radius: ${toString cfg.borders.radius}; }

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
}
