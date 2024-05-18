{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.sway.tabletMode.autoRotate {
    home.packages = with pkgs; [rot8];
    wayland.windowManager.sway.config.startup = [
      {command = "${lib.getExe pkgs.rot8}";}
    ];
  };
}
