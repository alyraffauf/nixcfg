{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.desktop.sway.redShift {
    home.packages = with pkgs; [gammastep];
    wayland.windowManager.sway.config.startup = [
      # {command = "${pkgs.geoclue2}/libexec/geoclue-2.0/demos/agent";}
      {command = "${lib.getExe pkgs.gammastep} -l 33.74:-84.38";}
    ];
  };
}
