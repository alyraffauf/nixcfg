{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    sharedModules = [
      {
        alyraffauf.desktop.hyprland = {
          enable = true;
          tabletMode.enable = true;
        };
        wayland.windowManager.hyprland.extraConfig = ''
          exec-once = ${lib.getExe pkgs.dconf} write /org/gnome/desktop/a11y/applications/screen-keyboard-enabled true
          exec-once = ${lib.getExe' pkgs.squeekboard "squeekboard"}
        '';
      }
    ];
    users.aly = import ../../aly.nix;
  };
}
