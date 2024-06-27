{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.desktop.sway.enable {
    programs = {
      sway = {
        enable = true;
        package = pkgs.swayfx;
      };
    };
  };
}
