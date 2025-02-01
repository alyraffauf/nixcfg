{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.theme.enable = lib.mkEnableOption "Gtk, Qt, and application colors.";

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
      ];
    };
  };
}
