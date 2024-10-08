{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home;
in {
  config = lib.mkIf cfg.theme.enable {
    home.packages = [
      pkgs.adwaita-icon-theme
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

    stylix.targets.gtk.extraCss = builtins.concatStringsSep "\n" [
      (lib.optionalString ((cfg.desktop.hyprland.enable || cfg.desktop.sway.enable) && !cfg.desktop.gnome.enable) ''
        window.background { border-radius: ${toString cfg.theme.borders.radius}; }

        tooltip {
          background-color: alpha(${config.lib.stylix.colors.withHashtag.base00}, ${builtins.toString config.stylix.opacity.popups});
          border-radius: ${toString cfg.theme.borders.radius};
          border: 1px solid ${config.lib.stylix.colors.withHashtag.base0D};
          color: white;
        }

        tooltip.background {
          background-color: alpha(${config.lib.stylix.colors.withHashtag.base00}, ${builtins.toString config.stylix.opacity.popups});
          border: 1px solid ${config.lib.stylix.colors.withHashtag.base0D};
        }'')

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
}
