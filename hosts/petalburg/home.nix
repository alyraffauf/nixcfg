{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        wayland.windowManager.hyprland.extraConfig = ''
          exec-once = ${lib.getExe inputs.iio-hyprland.packages.${pkgs.system}.default} "desc:Samsung Display Corp. 0x4152"
        '';

        ar.home.desktop.hyprland.tabletMode.enable = true;
      }
    ];
  };
}
