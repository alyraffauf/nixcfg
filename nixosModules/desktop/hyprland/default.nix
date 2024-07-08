{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.desktop.hyprland.enable {
    programs = {
      hyprland = {
        enable = true;
        package = pkgs.hyprland;
      };
    };
  };
}
