{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.theme.enable {
    home.packages = [
      pkgs.adwaita-icon-theme
      pkgs.liberation_ttf
      pkgs.libsForQt5.kio
    ];

    qt = lib.mkIf (!config.ar.home.desktop.kde.enable) {
      enable = true;
      platformTheme.name = "kde";
      style.name = "Breeze";
    };

    stylix = {
      iconTheme = {
        enable = true;
        dark = "Papirus-Dark";
        light = "Papirus";
        package = pkgs.papirus-icon-theme.override {color = "adwaita";};
      };

      targets.gtk.extraCss = builtins.concatStringsSep "\n" [
        (lib.optionalString ((cfg.desktop.hyprland.enable || cfg.desktop.sway.enable) && !cfg.desktop.gnome.enable) ''
          window.background { border-radius: ${toString cfg.theme.borders.radius}; }
        '')

        (lib.optionalString (
            (cfg.desktop.hyprland.enable || cfg.desktop.sway.enable) && (config.stylix.polarity == "light") && !cfg.desktop.gnome.enable
          ) ''
            tooltip {
              &.background { background-color: alpha(${config.lib.stylix.colors.withHashtag.base05}, ${builtins.toString config.stylix.opacity.popups}); }
              background-color: alpha(${config.lib.stylix.colors.withHashtag.base05}, ${builtins.toString config.stylix.opacity.popups});
            }'')

        (lib.optionalString (cfg.theme.gtk.hideTitleBar && !cfg.desktop.gnome.enable) ''
          /* No (default) title bar on wayland */
          headerbar.default-decoration {
            /* You may need to tweak these values depending on your GTK theme */
            border-radius: 0;
            border: 0;
            box-shadow: none;
            font-size: 0;
            margin-bottom: 50px;
            margin-top: -100px;
            min-height: 0;
            padding: 0;
          }

          .titlebar,
          .titlebar .background
          {
            border-radius: 0;
          }

          /* rm -rf window shadows */
          window.csd,             /* gtk4? */
          window.csd decoration { /* gtk3 */
            border-radius: 0;
            box-shadow: none;
          }'')
      ];
    };
  };
}
