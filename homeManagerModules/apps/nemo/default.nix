{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.nemo.enable {
    home.packages = with pkgs; [
      cinnamon.nemo
    ];

    dconf = {
      enable = true;
      settings = {
        "org/nemo/preferences".show-image-thumbnails = "always";
        "org/nemo/preferences/menu-config".background-menu-open-as-root =
          !(config.ar.home.desktop.hyprland.enable || config.ar.home.desktop.sway.enable);
        "org/nemo/preferences/menu-config".selection-menu-open-as-root =
          !(config.ar.home.desktop.hyprland.enable || config.ar.home.desktop.sway.enable);
      };
    };
  };
}
