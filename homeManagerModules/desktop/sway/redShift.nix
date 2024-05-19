{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.sway.redShift {
    home.packages = with pkgs; [gammastep];
    wayland.windowManager.sway.config.startup = [
      {command = "${lib.getExe pkgs.gammastep} -l 31.1:-94.1";} # TODO: automatic locations
    ];
  };
}
