{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.hyprland.redShift {
    home.packages = with pkgs; [gammastep];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once = ${pkgs.geoclue2}/libexec/geoclue-2.0/demos/agent
      exec-once = ${lib.getExe pkgs.gammastep}
    '';
  };
}
