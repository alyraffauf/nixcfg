{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    alyraffauf.desktop.waylandComp.enable = lib.mkDefault true;

    programs = {
      sway = {
        enable = true;
        package = pkgs.swayfx;
      };
    };
  };
}
