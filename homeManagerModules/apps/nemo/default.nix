{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.nemo.enable {
    home.packages = with pkgs; [
      cinnamon.nemo
    ];

    dconf = {
      enable = true;
      settings = {
        "org/nemo/preferences".show-image-thumbnails = "always";
        "org/nemo/preferences/menu-config".background-menu-open-as-root =
          !(config.alyraffauf.desktop.hyprland.enable || config.alyraffauf.desktop.sway.enable);
        "org/nemo/preferences/menu-config".selection-menu-open-as-root =
          !(config.alyraffauf.desktop.hyprland.enable || config.alyraffauf.desktop.sway.enable);
      };
    };
  };
}
