{
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.extraConfig = ''
        input {
          tablet {
            output = eDP-1
          }
          touchdevice {
            output = eDP-1
          }
        }

        # Extra bindings for petalburg.
        bind = , xf86launch4, exec, ${lib.getExe self.inputs.pp-adjuster.packages.${pkgs.system}.default}
        bind = , xf86launch2, exec, ${lib.getExe pkgs.playerctl} play-pause

        exec-once = ${lib.getExe self.inputs.iio-hyprland.packages.${pkgs.system}.default} "desc:Samsung Display Corp. 0x4152"
      '';

      ar.home.desktop.hyprland = {
        laptopMonitors = ["desc:Samsung Display Corp. 0x4152,preferred,auto,2,transform,0"];
        tabletMode = {
          enable = true;
          tabletSwitches = ["Lenovo Yoga Tablet Mode Control switch"];
        };
      };
    }
  ];
}
