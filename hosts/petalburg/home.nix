{
  lib,
  pkgs,
  self,
  ...
}: {
  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland.settings = {
        bind = [
          ",xf86launch4,exec,${lib.getExe self.inputs.pp-adjuster.packages.${pkgs.system}.default}"
          ",xf86launch2,exec,${lib.getExe pkgs.playerctl} play-pause"
        ];

        exec-once = [''${
            lib.getExe self.inputs.iio-hyprland.packages.${pkgs.system}.default
          } "desc:Samsung Display Corp. 0x4152"''];

        input = {
          tablet.output = "eDP-1";
          touchdevice.output = "eDP-1";
        };
      };
      
      ar.home.desktop.sway.enable = true;

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
