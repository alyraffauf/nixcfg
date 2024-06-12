{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.sway.enable {
    programs = {
      sway = {
        enable = true;
        package = pkgs.swayfx;
      };
    };
  };
}
