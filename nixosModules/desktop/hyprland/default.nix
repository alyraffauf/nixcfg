{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.hyprland.enable {
    programs = {
      hyprland = {
        enable = true;
        package = pkgs.hyprland;
      };
    };
  };
}
