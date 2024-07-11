{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.sway.redShift {
    home.packages = with pkgs; [gammastep];

    wayland.windowManager.sway.config.startup = [
      {command = "${lib.getExe pkgs.gammastep} -l 33.74:-84.38";}
    ];
  };
}
