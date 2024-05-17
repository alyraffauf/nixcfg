{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.desktop.sway.virtKeyboard {
    home.packages = with pkgs; [squeekboard];
    wayland.windowManager.sway.config.startup = [
      {command = "${lib.getExe' pkgs.squeekboard "squeekboard"}";}
    ];

    wayland.windowManager.sway.extraConfig = ''
      bindswitch --reload --locked tablet:on exec ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled true
      bindswitch --reload --locked tablet:off exec ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled false
    '';
  };
}
