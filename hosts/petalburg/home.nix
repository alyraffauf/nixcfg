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
          # Extra bindings for petalburg.
          bind = , xf86launch4, exec, ${lib.getExe inputs.nixhw.packages.${pkgs.system}.power-profile-adjuster}
          bind = , xf86launch2, exec, ${lib.getExe pkgs.playerctl} play-pause

          exec-once = ${lib.getExe inputs.iio-hyprland.packages.${pkgs.system}.default} "desc:Samsung Display Corp. 0x4152"
        '';

        ar.home.desktop.hyprland.tabletMode.enable = true;
      }
    ];
  };
}
