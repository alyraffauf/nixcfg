{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.hyprland.enable {
    alyraffauf.desktop.waylandComp.enable = lib.mkDefault true;

    programs = {
      hyprland = {
        enable = true;
        package = pkgs.hyprland;
      };
    };
  };
}
