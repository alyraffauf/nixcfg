{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.theme = {
    enable = lib.mkEnableOption "Gtk, Qt, and application colors.";

    borders = {
      radius = lib.mkOption {
        description = "Global border radius.";
        default = 10;
        type = lib.types.int;
      };
    };

    gtk.hideTitleBar = lib.mkOption {
      description = "Whether to hide GTK3/4 titlebars (useful for some window managers).";
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.theme.enable {
    home.packages = [
      pkgs.adwaita-icon-theme
      pkgs.liberation_ttf
    ];

    qt = lib.mkIf (!config.myHome.desktop.kde.enable) {
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
        (lib.optionalString (
            (cfg.desktop.hyprland.enable) && (config.stylix.polarity == "light") && !cfg.desktop.gnome.enable
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
