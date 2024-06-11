{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        alyraffauf.desktop.hyprland = {
          tabletMode.enable = true;
        };
        wayland.windowManager.hyprland.extraConfig = ''
          exec-once = ${lib.getExe inputs.iio-hyprland.packages.${pkgs.system}.default} "desc:Samsung Display Corp. 0x4152"
        '';
      }
    ];
    users.aly = import ../../homes/aly.nix;
  };
}
