{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.hyprland.tabletMode.virtKeyboard {
    home.packages = with pkgs; [squeekboard];

    wayland.windowManager.hyprland.extraConfig = ''
      exec-once = ${lib.getExe' pkgs.squeekboard "squeekboard"}
      bindl=,switch:on:Lenovo Yoga Tablet Mode Control switch,exec,${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled true
      bindl=,switch:off:Lenovo Yoga Tablet Mode Control switch,exec,${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled false
    '';
  };
}
