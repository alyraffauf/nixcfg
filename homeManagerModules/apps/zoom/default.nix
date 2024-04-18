{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.zoom.enable = lib.mkEnableOption "Enables Zoom.";};

  config = lib.mkIf config.alyraffauf.apps.zoom.enable {
    home.packages = with pkgs; [zoom-us];
  };
}
